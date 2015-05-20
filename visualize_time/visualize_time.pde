// colors
color NO_READING_COLOR = color(255,255,255);
color GOOD_READING_COLOR = color(10, 240, 12);
color POOR_SIGNAL_COLOR = color(240,250,11);

// entry drawing config
int ENTRY_WIDTH = 30;
int ENTRY_HEIGHT = 7;
int ENTRY_X_PADDING = 10;
int ENTRY_Y_PADDING = 0;

// viz draawing config
int VIZ_OFFSET_Y = 30;
int VIZ_OFFSET_X = 10;

// data config
int[] session1_ids = {334,389,497,523,604,613,659,677,695,721,749,758,244,235,433,640,172,587,226,361,442,505,703,190,424,415,127,136,488};
int[] session2_ids = {118,262,280,325,343,370,398,532,541,569,578,631,668,686,253,299,154,514,145,208,596,712,271,352,307,316,406,730};
String tablePath = "data/timelog-session1.csv";
String renderPath = "render/session1.png";

Table dataTable;

void setup() {
	dataTable = loadTable(tablePath, "header");
	int vizHeight = dataTable.getRowCount()*(ENTRY_HEIGHT+ENTRY_Y_PADDING);
	int vizWidth = dataTable.getRow(0).getColumnCount()*(ENTRY_WIDTH+ENTRY_X_PADDING);
	size(vizWidth+VIZ_OFFSET_X, vizHeight+VIZ_OFFSET_Y);
	// size(3000, 5000);
	noLoop();
}

void draw() {
	background(NO_READING_COLOR);
	drawTimeplot(dataTable, VIZ_OFFSET_X, VIZ_OFFSET_Y);
	drawHeader(session1_ids, 40, 20);
	save(renderPath);
}
