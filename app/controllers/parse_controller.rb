class ParseController < ApplicationController
  @@dir = "public/intex/"
  @@idlist = []

  #Security columns
    #cusip
    #fund,
    #date
    #moodys
    #s_p
    #fitch
    #ce_orig,
    #ce_cur,
    #title
    #qtr_cdr,
    #qtr_severity,
    #forclosure_reo
    #delinq_30_60_90

  require "fileutils"
  

  def index
    @list = {}
    @exist = []
    @record_date= Security.find(:first, :conditions => "title = 'record_date'", :select=>"date") 
  @funds = {'asarx'=>'Ultra Short Mortgage Fund','aultx'=>'Ultra Short Fund','ascpx'=>'Intermediate Mortgage Fund','asitx'=>'Short U.S. Government Fund','asmtx'=>'U.S. Government Mortgage Fund',}
    
    #get directories    
    @funds.each do |key,value|
      #if value[-3]=="xls"
        @list[key]= list_files("#{@@dir}#{key}")
        @list[key].each do |v|
          if Security.find(:first, :conditions => "filename = '#{v.chomp(".xls").chop}'") 
            @exist << v.chomp(".xls").chop
          end#if
        end#@each key do
     # end#if value[-3]
    end#@@funds each do
   end
  
 def list_files(dir)
    Dir.new(dir).entries.sort.delete_if { |x| ! (x =~ /xls$/) }
 end
 
   
 def parse_it
 params.delete("authenticity_token")
 params.delete("action")
 params.delete("controller")
 
 params.each do |key,value|
  lfile(value,key.chop)  
 end
      redirect_to "?ids=#{@@idlist.join(',')}"
 end
 
 
 def lfile(flname,fnd)   
  xlsheet = @@dir + fnd + "/" + flname
  @parsed_file = Excel.new(xlsheet) 
  @results = []
  @stem_label = []
  @stem_value = []
  @fhead_label = []  
  @fhead_value = []  
  @securityfill = {}
  @fldatefill ={}

  
  
  if @parsed_file.sheets.each do |wbook|
    unless wbook == "Sheet1"  
    @flkeys = {"cdr"=>"Default Rate","severity"=>"Default Severity","writedown"=>"Princ Writedown","principal"=>"Principal"}
      
    @parsed_file.default_sheet = wbook

    @stem_label = @parsed_file.column(1)
    @stem_value = @parsed_file.column(2)        
         
       if @parsed_file.default_sheet == @parsed_file.sheets.first 
         
       #===================================================== create the security  
         @skeys = {"delinq_30_60_90"=>"30,60,90 Delinq:","cusip"=>"CUSIP","moodys"=>"Curr Moody's","fitch"=>"Curr Fitch","s_p"=>"Curr S&P","date"=>"Latest update:","ce_orig"=>"Orig Support (%)","ce_cur"=>"Cur Support (%)","forclosure_reo"=>"Fclsr,REO:","cpr"=>"Prepay Rate"}
      
         @security = Security.new
         
         #set basic variables
         @security.title = @parsed_file.cell(1,'A')
         @security.fund = fnd
         @security.filename = flname.chomp(".xls").chop  
         
         #=====================================================load variables from stem
         @skeys.each do |@sk,sv|
           if temp = lv_get(@stem_label,@stem_value,sv)
             if @fk=="cpr"
                temp =temp.gsub(' CPR','')               
             end             
             @security[@sk]=temp
             @skeys.delete(@sk) 
           end            
         end
         
         #=====================================================load left right data from head section        
         if 4.upto(8) do |line|
           line_ar = @parsed_file.row(line)
           @skeys.each do |@sk,sv|           
              if sar_pos = line_ar.index(sv)
                @security[@sk]= line_ar.at(sar_pos+1)                
              end
            end#do 
         end#do
         end#if       
        
         #======================================================fill the security
        
           
         #======================================================save the security
          if @ex = Security.find_by_cusip_and_fund_and_date(@security.cusip,@security.fund,@security.date)
            @ex.update_attributes(@security.attributes)
            @@idlist << @ex.id#load the list
            @sec_id = @ex.id
          else @security.save
            @@idlist << @security.id#load the list for display   
            @sec_id = @security.id
          end#if security exists-update 
            
       end#if firstsheet 

       #======================================================create teh rist loss dates         
       @fldate = Fldate.new
         @flkeys.each do |@fk,fv|
           if temp = lv_get(@stem_label,@stem_value,fv)
             if @fk=="cdr"
                temp =temp.gsub(' cdr','')               
             end
            @fldate[@fk]= temp
            @flkeys.delete(@fk)
           end
         end  

         #find the row of floss header infp
         @loss_head_row = @stem_label.index("Period")
         @loss_head_row +=1
         
         @fhead_label = @parsed_file.row(@loss_head_row)
         @fhead_value = @parsed_file.row(@loss_head_row+1)
         #search for remaining keys
         @flkeys.each do |@sk,sv|
           if temp = lv_get( @fhead_label,@fhead_value,sv)
            @fldate[@sk]= temp
           end
         end   

         @write = @fhead_label.index("Princ Writedown")+1
         @date = @fhead_label.index("Date")+1
         
         #subtract the position of the floss header from teh whole column
         @lhead_trim =  @stem_label.size - @loss_head_row - 2
         @writerow = @parsed_file.column(@write)
         @writerow = @writerow.slice!(0-@lhead_trim,@lhead_trim)
         
         @daterow = @parsed_file.column(@date)
         @daterow = @daterow.slice!(0-@lhead_trim,@lhead_trim)

         #==============================================load results
         switch = "on"
         @writerow.each do |wrt|
            unless wrt == 0 or switch == "off"
              @fl_row = @writerow.index(wrt)
               @fldate.f_loss = @daterow.at(@fl_row)
              switch = "off"
              break
            end
         end
         
         #==============================================load results
         @results << @fldate
  
    end#    unless wbook == "Sheet1"  
  end#   each do |wbook| 
      @results.each do |r|
        r.security_id = @sec_id
       r.save
      end
             archive(flname,fnd)

  end#   if @parsed_file.sheets   
 end #def lfile
 
 
 def lv_get(ar1,ar2,arkey)
   #get a vlue of parrellel arrays from a search topic arkey
    if ar_pos = ar1.index(arkey)
     #return "help"
     return ar2.at(ar_pos)
    end
 end
  
def archive(flname2,fnd2) 
  ofile = "public/intex/" + fnd2 + "/" + flname2
  nfile = "public/intex/archive/" + fnd2 + "/" + flname2
  #@dir = fu.pwd 
  FileUtils.mv ofile, nfile
       
end  
end
