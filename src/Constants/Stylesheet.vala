namespace Paraula.Stylesheet {
    public const string APP = """
        @define-color colorPrimary #b75d59;
        @define-color colorSecondary #fbf9f1;
        @define-color textColorPrimary #fff;
        @define-color textColorSecondary #333333;
        .paraula-window {
            background-color: @colorPrimary;
        }
        .paraula-view {
            background-color: @colorSecondary;
        }
        .paraula-view:selected {
            background-color: @textColorSecondary;
            color: @textColorPrimary;
        }
    """;
}