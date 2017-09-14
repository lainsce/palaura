namespace Palaura.Stylesheet {
    public const string APP = """
        @define-color colorPrimary #b75d59;
        @define-color textColorPrimaryShadow #a45350;
        @define-color colorSecondary #fbf9f1;
        @define-color textColorPrimary #fff;
        @define-color textColorSecondary #333333;
        .palaura-window {
            background-color: @colorPrimary;
        }
        .palaura-view {
            background-color: @colorSecondary;
        }
        .palaura-view:selected {
            background-color: @textColorSecondary;
            color: @textColorPrimary;
        }
    """;
}