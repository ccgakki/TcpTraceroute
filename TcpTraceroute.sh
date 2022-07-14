#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
Green_font="\033[32m" && Red_font="\033[31m" && Font_suffix="\033[0m"
Info="${Green_font}[Info]${Font_suffix}"
Error="${Red_font}[Error]${Font_suffix}"
echo -e "${Green_font}
#======================================
# Project: worst_testrace For NextTrace
# Version: 1.0
# Author: KANIKIG (Modified By ccgakki)
# Github: https://github.com/KANIKIG
#======================================
${Font_suffix}"

check_system(){
	wget -h &> null
	if [ $? -ne 0 ]; then
		echo -e "${Info} 正在安装wget..."
		if   [[ ! -z "`cat /etc/issue | grep -iE "debian"`" ]]; then
			apt-get install wget -y
		elif [[ ! -z "`cat /etc/issue | grep -iE "ubuntu"`" ]]; then
			apt-get install wget -y
		elif [[ ! -z "`cat /etc/redhat-release | grep -iE "CentOS"`" ]]; then
			yum install wget -y
		else
			echo -e "${Error} system not support!" && exit 1
		fi
	fi
	
}
check_root(){
	[[ "`id -u`" != "0" ]] && echo -e "${Error} must be root user !" && exit 1
}

install(){
	[[ ! -f /usr/local/bin/nexttrace ]] && bash <(curl -Ls https://raw.githubusercontent.com/xgadget-lab/nexttrace/main/nt_install.sh)
	[[ ! -f /usr/local/bin/nexttrace ]] && echo -e "${Error} download failed, please check!" && exit 1
	chmod a+x /usr/local/bin/nexttrace
}



test_single(){
	echo -e "${Info} 请输入你要测试的目标 ip :"
	read -p "输入 ip 地址:" ip

	while [[ -z "${ip}" ]]
		do
			echo -e "${Error} 无效输入"
			echo -e "${Info} 请重新输入" && read -p "输入 ip 地址:" ip
		done
	# 这里屏蔽版本信息和版权信息行的显示
	nexttrace -T ${ip} | grep -v -E 'NextTrace|leo'
	
	repeat_test_single
}
repeat_test_single(){
	echo -e "${Info} 是否继续测试其他目标 ip ?"
	echo -e "1.是\n2.否"
	read -p "请选择:" whether_repeat_single
	while [[ ! "${whether_repeat_single}" =~ ^[1-2]$ ]]
		do
			echo -e "${Error} 无效输入"
			echo -e "${Info} 请重新输入" && read -p "请选择:" whether_repeat_single
		done
	[[ "${whether_repeat_single}" == "1" ]] && test_single
	[[ "${whether_repeat_single}" == "2" ]] && echo -e "${Info} 退出脚本 ..." && exit 0
}



test_alternative(){
	select_alternative
	set_alternative
	result_alternative
}
select_alternative(){
	echo -e "${Info} 选择需要测试的目标地址: \n1.中国电信\n2.中国联通\n3.中国移动\n4.教育网\n5.ipv6DNS地址"
	read -p "输入数字以选择:" ISP

	while [[ ! "${ISP}" =~ ^[1-5]$ ]]
		do
			echo -e "${Error} 无效输入"
			echo -e "${Info} 请重新选择" && read -p "输入数字以选择:" ISP
		done
}
set_alternative(){
	[[ "${ISP}" == "1" ]] && node_1
	[[ "${ISP}" == "2" ]] && node_2
	[[ "${ISP}" == "3" ]] && node_3
	[[ "${ISP}" == "4" ]] && node_4
  	[[ "${ISP}" == "5" ]] && node_5
}
node_1(){
	echo -e "1.上海电信(天翼云)\n2.厦门电信CN2\n3.广东东莞CN2\n4.上海CN2\n5.广东深圳电信\n6.广州电信(天翼云)\n7.常州电信ipv6" && read -p "输入数字以选择:" node

	while [[ ! "${node}" =~ ^[1-7]$ ]]
		do
			echo -e "${Error} 无效输入"
			echo -e "${Info} 请重新选择" && read -p "输入数字以选择:" node
		done

	[[ "${node}" == "1" ]] && ISP_name="上海电信(天翼云)"	       && ip=101.95.52.34
	[[ "${node}" == "2" ]] && ISP_name="厦门电信CN2"	   && ip=117.28.254.129
	[[ "${node}" == "3" ]] && ISP_name="广东东莞CN2"	     && ip=116.6.211.124
	[[ "${node}" == "4" ]] && ISP_name="上海CN2"	     && ip=58.32.32.1
	[[ "${node}" == "5" ]] && ISP_name="广东深圳电信"	     && ip=116.6.211.41
	[[ "${node}" == "6" ]] && ISP_name="广州电信(天翼云)" && ip=14.215.116.1
  [[ "${node}" == "7" ]] && ISP_name="常州电信IPV6" && ip=240e:978:309::1:42
}
node_2(){
	echo -e "1.上海联通9929\n2.上海联通\n3.河南郑州联通\n4.安徽合肥联通\n5.江苏南京联通\n6.浙江杭州联通\n7.常州联通ipv6" && read -p "输入数字以选择:" node

	while [[ ! "${node}" =~ ^[1-7]$ ]]
		do
			echo -e "${Error} 无效输入"
			echo -e "${Info} 请重新选择" && read -p "输入数字以选择:" node
		done

	[[ "${node}" == "1" ]] && ISP_name="上海联通9929" && ip=210.13.84.138
	[[ "${node}" == "2" ]] && ISP_name="上海联通"	 && ip=112.65.63.1
	[[ "${node}" == "3" ]] && ISP_name="河南郑州联通" && ip=61.168.23.74
	[[ "${node}" == "4" ]] && ISP_name="安徽合肥联通" && ip=112.122.10.26
	[[ "${node}" == "5" ]] && ISP_name="江苏南京联通" && ip=58.240.53.78
	[[ "${node}" == "6" ]] && ISP_name="浙江杭州联通" && ip=101.71.241.238
  	[[ "${node}" == "7" ]] && ISP_name="常州联通IPV6" && ip=2408:873c:3201::1:40
}
node_3(){
	echo -e "1.上海移动\n2.四川成都移动\n3.安徽合肥移动\n4.浙江杭州移动\n5.深圳移动IPV6\n6.成都移动IPV6" && read -p "输入数字以选择:" node

	while [[ ! "${node}" =~ ^[1-6]$ ]]
		do
			echo -e "${Error} 无效输入"
			echo -e "${Info} 请重新选择" && read -p "输入数字以选择:" node
		done

	[[ "${node}" == "1" ]] && ISP_name="上海移动"     && ip=211.136.163.96
	[[ "${node}" == "2" ]] && ISP_name="四川成都移动" && ip=183.221.247.9
	[[ "${node}" == "3" ]] && ISP_name="安徽合肥移动" && ip=120.209.140.60
	[[ "${node}" == "4" ]] && ISP_name="浙江杭州移动" && ip=112.17.0.106
  	[[ "${node}" == "5" ]] && ISP_name="深圳移动IPV6" && ip=2409:8c54:1020:2:1:1:69:211d
  	[[ "${node}" == "6" ]] && ISP_name="成都移动IPV6" && ip=2409:8c62:e10:101::e2
}
node_4(){
	ISP_name="北京教育网" && ip=202.205.6.30
}
node_5(){
	echo -e "1.谷歌ipv6DNS\n2.CFipv6DNS\n3.阿里ipv6DNS\n4.腾讯ipv6DNS\n5.百度ipv6DNS\n6.上交ipv6DNS" && read -p "输入数字以选择:" node

	while [[ ! "${node}" =~ ^[1-6]$ ]]
		do
			echo -e "${Error} 无效输入"
			echo -e "${Info} 请重新选择" && read -p "输入数字以选择:" node
		done

	[[ "${node}" == "1" ]] && ISP_name="谷歌ipv6DNS"     && ip=2001:4860:4860::8888
	[[ "${node}" == "2" ]] && ISP_name="CFipv6DNS" && ip=2606:4700:4700::1111
	[[ "${node}" == "3" ]] && ISP_name="阿里ipv6DNS" && ip=2400:3200::1
	[[ "${node}" == "4" ]] && ISP_name="腾讯ipv6DNS" && ip=2402:4e00::
  [[ "${node}" == "5" ]] && ISP_name="百度ipv6DNS" && ip=2400:da00::6666
  [[ "${node}" == "6" ]] && ISP_name="成都移动IPV6" && ip=2409:8c62:e10:101::e2
}

result_alternative(){
	echo -e "${Info} 测试路由 到 ${ISP_name} 中 ..."
	nexttrace -T ${ip} | grep -v -E 'NextTrace|leo'
	echo -e "${Info} 测试路由 到 ${ISP_name} 完成 ！"

	repeat_test_alternative
}

repeat_test_alternative(){
	echo -e "${Info} 是否继续测试其他节点?"
	echo -e "1.是\n2.否"
	read -p "请选择:" whether_repeat_alternative
	while [[ ! "${whether_repeat_alternative}" =~ ^[1-2]$ ]]
		do
			echo -e "${Error} 无效输入"
			echo -e "${Info} 请重新输入" && read -p "请选择:" whether_repeat_alternative
		done
	[[ "${whether_repeat_alternative}" == "1" ]] && test_alternative
	[[ "${whether_repeat_alternative}" == "2" ]] && echo -e "${Info} 退出脚本 ..." && exit 0
}

test_all(){
	# 电信CN2
	result_all  '58.32.32.1'	'上海电信CN2'
	result_all	'116.6.211.124'	'广东东莞CN2'
	# 上海电信
	result_all	'101.95.52.34'	'上海电信'
	# 联通9929商宽
	result_all  '210.13.84.138' '上海联通9929'
	result_all	'112.65.63.1'	'上海联通'
	result_all	'183.232.226.1'	'广州移动183'
	result_all	'120.197.96.1'	'广州移动120'
	# 清华大学镜像站
	result_all	'101.6.15.130'	'北京教育网'
  #三网ipv6
  result_all	'2409:8087:2001:10::2786:45cd'	'江苏移动ipv6'
  result_all	'2001:da8:8000:1:202:120:2:100'	'上交ipv6'
  result_all	'2001:da8:205:2060::188'	'北交ipv6'
	echo -e "${Info} 四网路由快速测试 已完成 ！"
}
result_all(){
	ISP_name=$2
	echo -e "${Info} 测试路由 到 ${ISP_name} 中 ..."
  #每跳检测1次
	nexttrace -T -q 1 $1 | grep -v -E 'NextTrace|leo'
	echo -e "${Info} 测试路由 到 ${ISP_name} 完成 ！"
}



check_system
check_root
install
clear
echo -e "${Info} 选择你要使用的功能: "
echo -e "1.选择一个节点进行测试\n2.四网IPV4&6路由快速测试\n3.手动输入 ip 进行测试"
read -p "输入数字以选择:" function

	while [[ ! "${function}" =~ ^[1-3]$ ]]
		do
			echo -e "${Error} 缺少或无效输入"
			echo -e "${Info} 请重新选择" && read -p "输入数字以选择:" function
		done

	if [[ "${function}" == "1" ]]; then
		test_alternative
	elif [[ "${function}" == "2" ]]; then
		test_all
	else
		test_single
	fi
