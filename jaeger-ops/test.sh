while :
do
	echo "Press [CTRL+C] to stop.."
	kubectl delete -f allinone.yaml
	kubectl apply -f allinone.yaml
	sleep 1
done
