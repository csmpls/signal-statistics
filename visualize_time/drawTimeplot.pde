void drawTimeplot(Table table, int offsetX, int offsetY) {
	for (int y = 0; y < table.getRowCount(); y++) {
	  	TableRow row = table.getRow(y);
		for (int x = 1; x < row.getColumnCount()-1; x++) {
	  		drawEntry(table.getInt(y,x), x-1, y, offsetX, offsetY);
		}
	}
}

void drawEntry(int value, int x, int y, int offsetX, int offsetY) {
	if (value == -1) {
		drawPoint(NO_READING_COLOR, x, y, offsetX, offsetY);
	} else if (value == 0) {
		drawPoint(GOOD_READING_COLOR, x, y, offsetX, offsetY);
	} else {
		drawPoint(POOR_SIGNAL_COLOR, x, y, offsetX, offsetY);
	}
}

void drawPoint(color colour, int x, int y, int offsetX, int offsetY) {
	fill(colour);
	stroke(colour);
	rect(
		x*(ENTRY_WIDTH+ENTRY_X_PADDING) + offsetX
		, y*(ENTRY_HEIGHT+ENTRY_Y_PADDING) + offsetY
		, ENTRY_WIDTH
		, ENTRY_HEIGHT);
}