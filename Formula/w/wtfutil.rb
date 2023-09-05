class Wtfutil < Formula
  desc "Personal information dashboard for your terminal"
  homepage "https://wtfutil.com"
  url "https://github.com/wtfutil/wtf.git",
      tag:      "v0.43.0",
      revision: "ea7f6ed1ce0e3a96c7ce7aa337bfdae9cfc27a93"
  license "MPL-2.0"
  head "https://github.com/wtfutil/wtf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d811c8da851a06afb1aa0f1396755385a3eace99e2abdbf58719619efecdd3b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2dde8a7584268f28be28e4ff1e98f8895314c2950d88d002830f7ed79ec51c52"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "efb3e2fd24e639a315cc5e50acd8a20dc4b454a6a8aff0dfb2c169c9eac6afd9"
    sha256 cellar: :any_skip_relocation, ventura:        "1c66eb6d6b8c4a9b3167163371c1d774b9df6f1dd36155b380ee83e82ac8e13d"
    sha256 cellar: :any_skip_relocation, monterey:       "4183402aa957eead2c29e62f9e1d6afb0940568d6b387e360ae4e0fdcc61be35"
    sha256 cellar: :any_skip_relocation, big_sur:        "717dcf43f6c5d8f55c3f0aefd8e255ef91aab685a02b668ed27ce375e1bc404a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c46aabfdfe08b790df12e07d83d93d0b1d10c4c963315979445ec220e2463372"
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
