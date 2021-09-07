class Wtfutil < Formula
  desc "Personal information dashboard for your terminal"
  homepage "https://wtfutil.com"
  url "https://github.com/wtfutil/wtf.git",
      tag:      "v0.39.0",
      revision: "eafc6a36e7ff2df2b2cf3ebfa65b2ef514aee2ec"
  license "MPL-2.0"
  head "https://github.com/wtfutil/wtf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bd204d5ffd2338f2aa50f391abff4f7489f3eca8fb70f8bb154402809694ac17"
    sha256 cellar: :any_skip_relocation, big_sur:       "f5671b2ba16b0db7fbc406fd8437d72cd94df73039babc21ad1766e066907984"
    sha256 cellar: :any_skip_relocation, catalina:      "d8dc00779d756e615e9aede4d7749da0bdb8159d8b6b991c887d7fa123121e4a"
    sha256 cellar: :any_skip_relocation, mojave:        "0cb8e780293cbdcf01d616afc4afdbde7ccb3268d92e941e1820e8a1eaaa2700"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b65af7a45ab65cff3deb74da07af7d5f66dc8e75ebf68e6c082052de66db6556"
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
