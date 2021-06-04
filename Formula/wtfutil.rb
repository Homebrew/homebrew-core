class Wtfutil < Formula
  desc "Personal information dashboard for your terminal"
  homepage "https://wtfutil.com"
  url "https://github.com/wtfutil/wtf.git",
      tag:      "v0.37.0",
      revision: "91942b68f203aa95e43dfa637165f0136a9343da"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "47c655855b109ebf85cda5c1ca99c0d6684e0cb0b864fb4c39404904c094c18d"
    sha256 cellar: :any_skip_relocation, big_sur:       "0cdc3d4bcb3c0396e272950f52fc70e656f4e39e9bb0a0ee0cf006e43ed97648"
    sha256 cellar: :any_skip_relocation, catalina:      "120fec92901e7afaddd226ef8dce48396df513f07af97af56a42bb63734736b6"
    sha256 cellar: :any_skip_relocation, mojave:        "d0b05f2c733430487369d2e5d4b4fcae88c8eb702ef0c7a3fe4d1acd992b42ec"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{Time.now.iso8601}
    ]
    system "go", "build", "-trimpath", "-ldflags", ldflags.join(" "), "-o", bin/"wtfutil"
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
