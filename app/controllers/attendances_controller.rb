class AttendancesController < ApplicationController
  def basic_info
    @user = User.find(current_user.id)
  end
  
  def ba_info_edit
    @user = User.find(current_user.id)
    if @user.update_attributes(user_params)
      # 更新に成功した場合を扱う。
      flash[:success] = "基本情報を修正しました"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def work
    if params[:flag] == "arrival_flag" #出勤ボタンを押下
          savetime = Time.new(Time.current.year,Time.current.month,Time.current.day,Time.current.hour,Time.current.min,00)
          date = Date.current
          # byebug
          if Attendance.find_by(attendance_date: date, user_id: params[:id]) == nil
            save = Attendance.new(user_id: params[:id], arrival: savetime, attendance_date: date)
            save.save
          else
            save = Attendance.find_by(attendance_date: date, user_id: params[:id])
            save.update(arrival: savetime)
          end
        flash[:success] = '今日も１日頑張りましょう。'
        params[:flag] = "" #フラグが内部保持されてしまうのでリセット → リセットしないと画面更新すると出勤イベントが反応してしまう為
    end
      
      if params[:flag] == "departure_flag" #退勤ボタンを押下
        savetime = Time.new(Time.current.year,Time.current.month,Time.current.day,Time.current.hour,Time.current.min,00)
        date = Date.current
        save = Attendance.find_by(attendance_date: date, user_id: params[:id])
        if save.present?
          save.update(departure: savetime)
          params[:flag] == "" #フラグが内部保持されてしまうのでリセット → リセットしないと画面更新すると退勤イベントが反応してしまう為
        end
      flash[:success] = '今日も１日お疲れ様でした。'
      end
    redirect_to user_path(params[:id])
  end
  
  def attend_update
    @user = User.find(current_user.id)
    error_count = 0
    message = ""
    
    works_params.each do |id, item|
          attendance = Attendance.find(current_user.id)
          
          #出社時間と退社時間の両方の存在を確認
          if item["arrival"].blank? && item["departure"].blank?
            message = '一部編集が無効となった項目があります。'
            
            # 当日以降の編集はadminユーザのみ
          elsif attendance.attendance_date > Date.current && !current_user.admin?
            message = '明日以降の勤怠編集は出来ません。'
            error_count += 1
          
          #出社時間 > 退社時間ではないか
          elsif item["arrival"].to_s > item["departure"].to_s
            message = '出社時間より退社時間が早い項目がありました'
            error_count += 1
          end
    end #eachの締め
    
    if error_count > 0
      flash[:warning] = message
    else
      works_params.each do |id, item|
          attendance = Attendance.find(id)
          
          # 当日以降の編集はadminユーザのみ
          if item["arrival"].blank? && item["departure"].blank?
          
          else
            attendance.update_attributes(item)
            flash[:success] = '勤怠時間を更新しました。'
          end
      end #eachの締め
    end
    # redirect_to("/attendances/attend_edit")
    redirect_to url:{:action=>"show", :controller=>"users", :id=>params[:id]}
  end
  
  def attend_edit
    @user = User.find(params[:id])
    # @attendance = Attendance.find_by(user_id: @user.id)
    @y_m_d = Date.current
    @youbi = %w[日 月 火 水 木 金 土]    

    @first_day = params[:first_day].to_date
    # ▼月末(30or31日, 23:59:59)を取得します
    @last_day = @first_day.end_of_month
    # @to = DateTime.current.next_month.beginning_of_month
    # @attendance = Attendance.where(created_at: @first_day...@last_day, user_id: @user.id)
  end
end

  private
    def works_params
       params.permit(attendances: [:arrival, :departure])[:attendances]
    end
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :affiliation,
                                   :password_confirmation, :pointing_work_time, :basic_work_time)
    end