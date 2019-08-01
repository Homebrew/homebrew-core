class Wtfutil < Formula
  desc "The personal information dashboard for your terminal"
  homepage "https://wtfutil.com"
  url "https://github.com/wtfutil/wtf.git",
    :tag      => "v0.19.1",
    :revision => "45da40e4c9ffe35a3c0501f580edc8a5182c9546"

  bottle do
    cellar :any_skip_relocation
    sha256 "5927d8b5b9db61af28f03b2f8524ee3b83d760907d7f4ba30de4657f30f329a4" => :mojave
    sha256 "33e969bdbfbe25920ee5a6604a411917639182a4a72bcbb2ba82d269090a43ce" => :high_sierra
    sha256 "ec16a65458c2247a235f066220fc10764ece2aaf30e35101c5c7ddac093a28a2" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "on"
    ENV["GOPATH"] = buildpath
    ENV["GOPROXY"] = "https://gocenter.io"

    dir = buildpath/"src/github.com/wtfutil/wtf"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-o", bin/"wtfutil"
      prefix.install_metafiles
    end
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
