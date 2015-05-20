void drawHeader(int[] id_list, int x_padding, int y_padding) {
	for (int x = 0; x<id_list.length; x++) {
		fill(0);
		textSize(10);
		text(Integer.toString(id_list[x]), x*x_padding+VIZ_OFFSET_X, y_padding);
	}
}
