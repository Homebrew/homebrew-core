class Wtfutil < Formula
  desc "Personal information dashboard for your terminal"
  homepage "https://wtfutil.com"
  url "https://github.com/wtfutil/wtf/archive/refs/tags/v0.49.0.tar.gz"
  sha256 "700024091ed2db2ce1f38e20735e4edf7e9179a697ffd361851e63342b652cee"
  license "MPL-2.0"
  head "https://github.com/wtfutil/wtf.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca9bf8c4528b24eedebc8e4b68ad7c994402aed6cf1842a521291cb593ac6271"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c2fba2de0dce9e98bec0bc62e36264bdf2791ca2baae53bbfd268cbcfa63aa5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e454f198d7879502bce0173e6feed3798a662dca25dfb853f07228d0fc6c78d"
    sha256 cellar: :any_skip_relocation, sonoma:        "56e56d9b2fa53cc7a35aa88e672d73df067d747a8f2f6768d6df12e09ce8163d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2bf1fb03df8f5a0967a579047d5b0cf04ec1984658f9f2bf0570224f7dca046f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5bbdeb0fbfabcdf2c5ef3166ac84815c8a76c25eee564a03cc76a2c8595cf86"
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
