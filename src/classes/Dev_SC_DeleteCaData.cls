global class Dev_SC_DeleteCaData implements Schedulable {
	global void execute(SchedulableContext sc) {
		Dev_BT_DeleteCaData b = new Dev_BT_DeleteCaData();
		database.executebatch(b);
	}
}