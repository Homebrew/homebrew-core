class Talisman < Formula
  desc "Tool to detect and prevent secrets from getting checked in"
  homepage "https://thoughtworks.github.io/talisman/"
  url "https://github.com/thoughtworks/talisman",
      :using    => :git,
      :tag      => "v1.0.0",
      :revision => "dd7b5898f7c4d9013d23d4dbd34685611524ac20"

  depends_on "go" => :build
  depends_on "gox" => :build

  def install
    system "./build"
    bin.install "./talisman_darwin_amd64" => "talisman"
  end

  test do
    system "git", "init", "."
    expected = <<~TOUT


      d8888b. db    db d8b   db d8b   db d888888b d8b   db  d888b    .d8888.  .o88b.  .d8b.  d8b   db
      88  `8D 88    88 888o  88 888o  88   `88'   888o  88 88' Y8b   88'  YP d8P  Y8 d8' `8b 888o  88
      88oobY' 88    88 88V8o 88 88V8o 88    88    88V8o 88 88        `8bo.   8P      88ooo88 88V8o 88
      88`8b   88    88 88 V8o88 88 V8o88    88    88 V8o88 88  ooo     `Y8b. 8b      88~~~88 88 V8o88
      88 `88. 88b  d88 88  V888 88  V888   .88.   88  V888 88. ~8~   db   8D Y8b  d8 88   88 88  V888 db db
      88   YD ~Y8888P' VP   V8P VP   V8P Y888888P VP   V8P  Y888P    `8888Y'  `Y88P' YP   YP VP   V8P VP VP



      Please check 'talisman_reports/data' folder for the talisman scan report

    TOUT

    assert_equal expected, shell_output(bin/"talisman --scan")
  end
end
