class Wtfutil < Formula
  desc "The personal information dashboard for your terminal"
  homepage "https://wtfutil.com"
  url "https://github.com/wtfutil/wtf.git",
    :tag      => "v0.23.0",
    :revision => "e98b15ca2cefddb285ad9d73b4fd2b35ca2c1d32"

  bottle do
    cellar :any_skip_relocation
    sha256 "b1001fc9292bc165d9fb2df04fd83a90d26ab19e11cb6fc89aa95a63f433d799" => :catalina
    sha256 "68433b8dab63a55f63203de96d9a164e4a852f47466c0d37651a50b4fb7f7bdc" => :mojave
    sha256 "ca949a320f6b6acf5870f1118a4923b2b153f6d688b3a51f871c95a4021d88cb" => :high_sierra
    sha256 "379bb4e2f60cc0d2a63182324f3695681c738e6cd29ceeb9f4ac1fd3ad9e0e5b" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPROXY"] = "https://gocenter.io"
    system "go", "build", "-o", bin/"wtfutil"
  end

  test do
    testconfig = testpath/"config.yml"
    testconfig.write <<~EOS
      wtf:
        colors:
          background: "red"
          border:
            focusable: "darkslateblue"
            focused: "orange"
            normal: "gray"
          checked: "gray"
          highlight:
            fore: "black"
            back: "green"
          text: "white"
          title: "white"
        grid:
          # How _wide_ the columns are, in terminal characters. In this case we have
          # six columns, each of which are 35 characters wide
          columns: [35, 35, 35, 35, 35, 35]

          # How _high_ the rows are, in terminal lines. In this case we have five rows
          # that support ten line of text, one of three lines, and one of four
          rows: [10, 10, 10, 10, 10, 3, 4]
        navigation:
          shortcuts: true
        openFileUtil: "open"
        sigils:
          checkbox:
            checked: "x"
            unchecked: " "
          paging:
            normal: "*"
            selected: "_"
        term: "xterm-256color"
    EOS

    begin
      pid = fork do
        exec "#{bin}/wtfutil", "--config=#{testconfig}"
      end
    ensure
      Process.kill("HUP", pid)
    end
  end
end
