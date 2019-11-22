class Wtfutil < Formula
  desc "The personal information dashboard for your terminal"
  homepage "https://wtfutil.com"
  url "https://github.com/wtfutil/wtf.git",
    :tag      => "v0.24.0",
    :revision => "a6468c585b11826a7d5284699571396499ab7aae"

  bottle do
    cellar :any_skip_relocation
    sha256 "d69582354c189a7df774084a328a1f181e361cfa1d17588d2cbdf597c2ddd165" => :catalina
    sha256 "97a30eb80a347cae086c7d2889b08f3790955618375885d860b25da4e296b586" => :mojave
    sha256 "0e57d38359e60da17118c1630c363918a07b1d6599420e1699f85d3c94c27c5f" => :high_sierra
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
