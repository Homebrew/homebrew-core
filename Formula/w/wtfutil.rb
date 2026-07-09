class Wtfutil < Formula
  desc "Personal information dashboard for your terminal"
  homepage "https://wtfutil.com"
  url "https://github.com/wtfutil/wtf/archive/refs/tags/v0.50.0.tar.gz"
  sha256 "cec9b0a4d01dd6d2a81a8cd429e992786a2a3a212d4e2c090ab4d10172ca9794"
  license "MPL-2.0"
  head "https://github.com/wtfutil/wtf.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ea6938225069f6512debc79090300e93255eccb23c808e6b735399bdf770156"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcb07cc6d7a924e00969fc1bf6b6b77c478588ae7e0bfd613e4c7fb287c86fb0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5435bdf1477ed48580cb7f3c35f6b6341364160cb70d645dc3bc415c6ce9652d"
    sha256 cellar: :any_skip_relocation, sonoma:        "22ccab71cb51acea3500ad7ab7936cb85a494e4b391c836f9510780cf553e065"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb863500bb7249c9baa2607b7c0cf3a47035ed62904bbebc3f446a17ca33bfb0"
    sha256 cellar: :any,                 x86_64_linux:  "6fd1868752f7e160cff65cb962484c0f7a577f1226f5d2c81b81f239999e29f4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    testconfig = testpath/"config.yml"
    testconfig.write <<~YAML
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
    YAML

    begin
      pid = fork do
        exec bin/"wtfutil", "--config=#{testconfig}"
      end
    ensure
      Process.kill("HUP", pid)
    end
  end
end
