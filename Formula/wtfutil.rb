class Wtfutil < Formula
  desc "Personal information dashboard for your terminal"
  homepage "https://wtfutil.com"
  url "https://github.com/wtfutil/wtf.git",
      tag:      "v0.39.2",
      revision: "1dc4115bcb5e15534d06543e275f72dfdb550bc6"
  license "MPL-2.0"
  head "https://github.com/wtfutil/wtf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0087a906e160dce6afde89f20d056c88503c308362576abf23cfc9f7f1ad9943"
    sha256 cellar: :any_skip_relocation, big_sur:       "6ca8e81a096523c0ac2265b85e106a1c223015310bd79a774f8fe273647377f6"
    sha256 cellar: :any_skip_relocation, catalina:      "977b8c6e48a5233ad69973bfc75c6190d3f74d81dfc780b3323675f3f8b96825"
    sha256 cellar: :any_skip_relocation, mojave:        "267f0d2b52a91e56aaca45429efeda90ad007e4f1877d65dc6e0ccd09f8be9cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e1b3187db2b9c39a7908cff30e3438290d9bece81aafc1a264a3e297500bebc"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags: ldflags)
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
