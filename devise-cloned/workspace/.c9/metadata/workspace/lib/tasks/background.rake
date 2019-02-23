{"changed":false,"filter":false,"title":"background.rake","tooltip":"/lib/tasks/background.rake","value":"namespace :background do\n  desc \"TODO\"\n  \n  task last: :environment do\n    require 'one_signal'\n    require 'open-uri'\n    require 'rufus-scheduler'\n    \n    \n    scheduler = Rufus::Scheduler.new\n    scheduler.every '1h' do\n      for i in 1..User.count\n        user = User.find(i)\n        user.message_flag = true\n        user.save\n        puts user.name + \"님 메시지 플래그 초기화\"\n      end\n    end\n    \n    scheduler.every '5m' do\n      url='https://finance.naver.com/marketindex/exchangeDetail.nhn?marketindexCd=FX_JPYKRW_SHB'\n      doc=Nokogiri::HTML(open(url),nil, 'euc-kr')\n      currency=doc.css('p.no_today')\n      @new_currency=currency.map{|cur| cur.text} #지금 100엔당 얼마인지?\n      currency_name=doc.css(\"h3.h_lst\")\n      @new_currency_name=currency_name.map{|cur_n| cur_n.text} #외환명이라는데\n      @new_currency[0].gsub!(\",\",\"\")\n      @new_currency[0].gsub!(\" \",\"\")\n      @new_currency[0].gsub!(\"원\",\"\")\n      rate = @new_currency[0].to_f\n      OneSignal::OneSignal.api_key = \"N2YwYjc1MjItNGVmZS00YmVjLWE5NjUtMzBmMDUzMDJiNzY5\"\n      OneSignal::OneSignal.user_auth_key = \"OWE3NWM4NDYtMTMyZi00NGM1LTgyOGYtODY4NzRlYThlZjVm\"\n      app_id = \"88272bce-6e40-4dd9-9d37-8766fdbfcd99\"\n      \n      \n      sendArray = []\n      \n      for i in 1..User.count\n        user = User.find(i)\n        if user.subscribe_flag == true and user.rate >= rate and user.message_flag == true and user.onesignal_id != \"\" and user.rate != 999999.0\n        # if user.rate >= rate and user.onesignal_id != \"\"\n  \n          sendArray.push(user.onesignal_id)\n          user.message_flag = false\n          user.save\n          puts user.email+\"에게 메일 보내기 성공\"\n        end\n      end\n      time1 = Time.new\n      if sendArray.length != 0\n        params ={\n          include_player_ids: sendArray,\n          app_id: app_id,\n          language: \"ko\",\n          contents: {\n              en: \"지정하신 환율에 도달했습니다: \" + rate.to_s + \"円\"\n          }\n        }\n        OneSignal::Notification.create(params: params)\n        puts \"=========================================성공=============================================\"\n      else\n        puts \"보낼 사람이 없습니다\"\n      end\n      puts \"알리미 프로세스 완료\"\n    end\n    scheduler.join\n  end\n  \n  \n  task oo: :environment do\n    require 'one_signal'\n    require 'open-uri'\n    \n    url='https://finance.naver.com/marketindex/exchangeDetail.nhn?marketindexCd=FX_JPYKRW_SHB'\n    doc=Nokogiri::HTML(open(url),nil, 'euc-kr')\n    currency=doc.css('p.no_today')\n    @new_currency=currency.map{|cur| cur.text} #지금 100엔당 얼마인지?\n    currency_name=doc.css(\"h3.h_lst\")\n    @new_currency_name=currency_name.map{|cur_n| cur_n.text} #외환명이라는데\n    @new_currency[0].gsub!(\",\",\"\")\n    @new_currency[0].gsub!(\" \",\"\")\n    @new_currency[0].gsub!(\"원\",\"\")\n    rate = @new_currency[0].to_f\n    OneSignal::OneSignal.api_key = \"N2YwYjc1MjItNGVmZS00YmVjLWE5NjUtMzBmMDUzMDJiNzY5\"\n    OneSignal::OneSignal.user_auth_key = \"OWE3NWM4NDYtMTMyZi00NGM1LTgyOGYtODY4NzRlYThlZjVm\"\n    app_id = \"88272bce-6e40-4dd9-9d37-8766fdbfcd99\"\n    \n    \n    sendArray = []\n    \n    for i in 1..User.count\n      user = User.find(i)\n      if user.subscribe_flag == true and user.rate >= rate and user.message_flag == true and user.onesignal_id != \"\" and user.rate != 999999.0\n      # if user.rate >= rate and user.onesignal_id != \"\"\n\n        sendArray.push(user.onesignal_id)\n        user.message_flag = false\n        user.save\n        puts user.email+\"에게 메일 보내기 성공\"\n      end\n    end\n    time1 = Time.new\n    if sendArray.length != 0\n      params ={\n        include_player_ids: sendArray,\n        app_id: app_id,\n        language: \"ko\",\n        contents: {\n            en: \"지정하신 환율에 도달했습니다: \" + rate.to_s + \"円\" + \"Current Time : \" + time1.inspect\n        }\n      }\n      OneSignal::Notification.create(params: params)\n      puts \"=========================================성공=============================================\"\n    else\n      puts \"보낼 사람이 없습니다\"\n    end\n    puts \"알리미 프로세스 완료\"\n  end\n  task testing: :environment do\n    require 'rufus-scheduler'\n    require 'one_signal'\n    require 'open-uri'\n    scheduler = Rufus::Scheduler.new\n    scheduler.every '20s' do\n      puts \"10s job\"\n      puts \"Unset message_flag\"\n      for i in 1..User.count\n        user = User.find(i)\n        user.message_flag = true\n        user.save\n      end\n    end\n    \n    scheduler.every '20s' do\n      url='https://finance.naver.com/marketindex/exchangeDetail.nhn?marketindexCd=FX_JPYKRW_SHB'\n      doc=Nokogiri::HTML(open(url),nil, 'euc-kr')\n      currency=doc.css('p.no_today')\n      @new_currency=currency.map{|cur| cur.text} #지금 100엔당 얼마인지?\n      currency_name=doc.css(\"h3.h_lst\")\n      @new_currency_name=currency_name.map{|cur_n| cur_n.text} #외환명이라는데\n      @new_currency[0].gsub!(\",\",\"\")\n      @new_currency[0].gsub!(\" \",\"\")\n      @new_currency[0].gsub!(\"원\",\"\")\n      rate = @new_currency[0].to_f\n      OneSignal::OneSignal.api_key = \"N2YwYjc1MjItNGVmZS00YmVjLWE5NjUtMzBmMDUzMDJiNzY5\"\n      OneSignal::OneSignal.user_auth_key = \"OWE3NWM4NDYtMTMyZi00NGM1LTgyOGYtODY4NzRlYThlZjVm\"\n      app_id = \"88272bce-6e40-4dd9-9d37-8766fdbfcd99\"\n      \n      \n      sendArray = []\n      \n      for i in 1..User.count\n        user = User.find(i)\n        # if user.rate >= rate and user.message_flag == true and user.onesignal_id != \"\"\n        if user.rate >= rate and user.onesignal_id != \"\"\n\n          sendArray.push(user.onesignal_id)\n          user.message_flag = false\n          user.save\n          puts user.email+\"에게 메일 보내기 성공\"\n        end\n      end\n      time1 = Time.new\n      if sendArray.length != 0\n        params ={\n          include_player_ids: sendArray,\n          app_id: app_id,\n          language: \"ko\",\n          contents: {\n              en: \"지정하신 환율에 도달했습니다: \" + rate.to_s + \"円\" + \"Current Time : \" + time1.inspect\n          }\n        }\n        OneSignal::Notification.create(params: params)\n        puts \"=========================================성공=============================================\"\n      else\n        puts \"보낼 사람이 없습니다\"\n      end\n      puts \"20s job\"\n    end\n    scheduler.join\n  end\n  \n  task t: :environment do\n    require 'rufus-scheduler'\n    # require 'rufus-scheduler'\n    require 'one_signal'\n    require 'open-uri'\n    scheduler = Rufus::Scheduler.new\n    scheduler.every '20m' do\n      puts \"10s job\"\n      puts \"Unset message_flag\"\n      for i in 1..User.count\n        user = User.find(i)\n        user.message_flag = true\n        user.save\n      end\n    end\n    scheduler.every '10s' do\n      url='https://finance.naver.com/marketindex/exchangeDetail.nhn?marketindexCd=FX_JPYKRW_SHB'\n      doc=Nokogiri::HTML(open(url),nil, 'euc-kr')\n      currency=doc.css('p.no_today')\n      @new_currency=currency.map{|cur| cur.text} #지금 100엔당 얼마인지?\n      currency_name=doc.css(\"h3.h_lst\")\n      @new_currency_name=currency_name.map{|cur_n| cur_n.text} #외환명이라는데\n      @new_currency[0].gsub!(\",\",\"\")\n      @new_currency[0].gsub!(\" \",\"\")\n      @new_currency[0].gsub!(\"원\",\"\")\n      rate = @new_currency[0].to_f\n      OneSignal::OneSignal.api_key = \"N2YwYjc1MjItNGVmZS00YmVjLWE5NjUtMzBmMDUzMDJiNzY5\"\n      OneSignal::OneSignal.user_auth_key = \"OWE3NWM4NDYtMTMyZi00NGM1LTgyOGYtODY4NzRlYThlZjVm\"\n      app_id = \"88272bce-6e40-4dd9-9d37-8766fdbfcd99\"\n      \n      \n      sendArray = []\n      \n      for i in 1..User.count\n        user = User.find(i)\n        if user.rate >= rate and user.message_flag == true and user.onesignal_id != \"\"\n        # if user.rate >= rate and user.onesignal_id != \"\"\n\n          sendArray.push(user.onesignal_id)\n          user.message_flag = false\n          user.save\n          puts user.email+\"에게 메일 보내기 성공\"\n        end\n      end\n      time1 = Time.new\n      if sendArray.length != 0\n        params ={\n          include_player_ids: sendArray,\n          app_id: app_id,\n          language: \"ko\",\n          contents: {\n              en: \"지정하신 환율에 도달했습니다: \" + rate.to_s + \"円\" + \"Current Time : \" + time1.inspect\n          }\n        }\n        OneSignal::Notification.create(params: params)\n        puts \"=========================================성공=============================================\"\n      else\n        puts \"보낼 사람이 없습니다\"\n      end\n      puts \"20s job\"\n    end\n    \n    scheduler.join\n  end\n  task crawling: :environment do\n    require 'open-uri'\n    \n    require 'rufus-scheduler'\n\n    scheduler = Rufus::Scheduler.new\n    \n    scheduler.every '10s' do\n      url='https://finance.naver.com/marketindex/exchangeDetail.nhn?marketindexCd=FX_JPYKRW_SHB'\n      doc=Nokogiri::HTML(open(url),nil, 'euc-kr')\n      currency=doc.css('p.no_today')\n      @new_currency=currency.map{|cur| cur.text} # 지금 100엔당 얼마인지?\n      currency_name=doc.css(\"h3.h_lst\")\n      @new_currency_name=currency_name.map{|cur_n| cur_n.text} # 외환명 (지우면 에러)\n      @new_currency[0].gsub!(\",\",\"\")\n      @new_currency[0].gsub!(\" \",\"\")\n      @new_currency[0].gsub!(\"원\",\"\")\n      puts @new_currency[0] + \"성공\"\n    end\n    \n    scheduler.join\n  end\n  \n  task unset: :environment do\n    for i in 1..User.count\n      user = User.find(i)\n      user.message_flag = true\n      user.save\n    end\n  end\n  \n  task test: :environment do\n    \n    require 'rufus-scheduler'\n\n    scheduler = Rufus::Scheduler.new\n    \n    scheduler.every '3s' do\n      time1 = Time.new\n      puts \"Current Time : \" + time1.inspect\n    end\n    \n    scheduler.join\n  end\n  \n  task send: :environment do\n    \n    require 'one_signal'\n    require 'rufus-scheduler'\n    require 'open-uri'\n    time1 = Time.new\n    scheduler = Rufus::Scheduler.new\n    \n    scheduler.every '15s' do\n      url='https://finance.naver.com/marketindex/exchangeDetail.nhn?marketindexCd=FX_JPYKRW_SHB'\n      doc=Nokogiri::HTML(open(url),nil, 'euc-kr')\n      currency=doc.css('p.no_today')\n      @new_currency=currency.map{|cur| cur.text} #지금 100엔당 얼마인지?\n      currency_name=doc.css(\"h3.h_lst\")\n      @new_currency_name=currency_name.map{|cur_n| cur_n.text} #외환명이라는데\n      @new_currency[0].gsub!(\",\",\"\")\n      @new_currency[0].gsub!(\" \",\"\")\n      @new_currency[0].gsub!(\"원\",\"\")\n      rate = @new_currency[0].to_f\n      OneSignal::OneSignal.api_key = \"N2YwYjc1MjItNGVmZS00YmVjLWE5NjUtMzBmMDUzMDJiNzY5\"\n      OneSignal::OneSignal.user_auth_key = \"OWE3NWM4NDYtMTMyZi00NGM1LTgyOGYtODY4NzRlYThlZjVm\"\n      app_id = \"88272bce-6e40-4dd9-9d37-8766fdbfcd99\"\n      puts rate.to_s\n      \n      sendArray = []\n      \n      for i in 1..User.count\n        user = User.find(i)\n        if user.rate >= rate and user.message_flag == true and user.onesignal_id != \"\"\n          sendArray.push(user.onesignal_id)\n          user.message_flag = false\n          user.save\n        end\n      end\n      \n      if sendArray.length != 0\n        params ={\n          include_player_ids: sendArray,\n          app_id: app_id,\n          language: \"ko\",\n          contents: {\n              en: \"지정하신 환율에 도달했습니다: \" + rate.to_s + \"円\" + \"Current Time : \" + time1.inspect\n          }\n        }\n        OneSignal::Notification.create(params: params)\n        puts \"=========================================성공=============================================\"\n      else\n        puts \"보낼 사람이 없습니다\"\n      end\n    end\n    \n    scheduler.join\n    \n  end\n  \n  \n  \nend\n","undoManager":{"mark":-1,"position":-1,"stack":[]},"ace":{"folds":[],"scrolltop":627,"scrollleft":0,"selection":{"start":{"row":55,"column":55},"end":{"row":55,"column":55},"isBackwards":false},"options":{"guessTabSize":true,"useWrapMode":false,"wrapToView":true},"firstLineState":{"row":38,"state":"start","mode":"ace/mode/ruby"}},"timestamp":1535138700461}