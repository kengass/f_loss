class ViewerController < ApplicationController
    auto_complete_for :security,:cusip
    protect_from_forgery :exclude => [:auto_complete_for_security_cusip]    
def index
    @titles = Security.find(:all,:conditions=> ["date > ?",@vdate],:select=>"cusip, id",:order =>"cusip")
    @funds = {'asarx'=>'Ultra Short Mortgage Fund','aultx'=>'Ultra Short Fund','ascpx'=>'Intermediate Mortgage Fund','asitx'=>'Short U.S. Government Fund','asmtx'=>'U.S. Government Mortgage Fund',}

  if params[:fund] or params[:id] or params[:ids]
    @results =[] 
    @list=[]
    params.keys.each do |ke|
    case ke
      when "fund"
        @pagetitle = "<h3>All securities for #{@funds[params[:fund]]} for #{Date::MONTHNAMES[@vdate.mon]}</h3>"
        unless @list = Security.find(:all, :conditions=> ["fund = ? AND date > ? ",params[:fund],@vdate],:order =>"cusip")
               flash[:notice] = 'There are no securities for that date.'              
        end
      when "ids"
        params[:ids].scan(/\w/).each do |i|
          @list << Security.find_by_id(i) 
          @pagetitle = "<h3>The following secirities have been added to the database:</h3>"          
        end

      when "id"
       unless  @list << Security.find_by_id(params[:id])
        @pagetitle = "<h3>Report for security #{@list[0].cusip} as of #{@list[0].date}</h3>"      
          flash[:notice] = 'Specified security does not exist.'     
       else
          flash[:notice] = 'Specified security does not exist.'     

       end
    end 
    end#params each do ke
    @list.each do |l|
      res = {}#clear the temp storage variable
      unless res['sec'] = l
               flash[:notice] = 'Specified security does not exist.'              
      end
        
      #=================================================build F_loss dates
      if @fldates = Fldate.find(:all, :conditions=> ["security_id = ?",l.id],:select=>"severity, cdr, f_loss",:order =>"severity, cdr")
      @table = {}
      @sev= []
      @cdr= []

      res['fldates']=@fldates

      #================get unique 
      @fldates.each do |d|
        @sev << d.severity
        @cdr << d.cdr          
      end
      res["sevs"]=@sev.uniq!#flatten severity numbers 
      res["cdrs"]=@cdr.uniq!#flatten cdr numbers
       
      else
        flash[:notice] = 'Specified security does not have first loss dates.'              
      end
        @results << res  
      end#list.each do 
  end#if params
end
  
def build_date
end

end
