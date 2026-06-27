class Wtfutil < Formula
  desc "Personal information dashboard for your terminal"
  homepage "https://wtfutil.com"
  url "https://github.com/wtfutil/wtf/archive/refs/tags/v0.49.1.tar.gz"
  sha256 "77860a2bc3a14ebea15a8f31b388fd14a09dd2ecaade4e82079331c094896bb6"
  license "MPL-2.0"
  head "https://github.com/wtfutil/wtf.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e8559579aac3cfab8ecd70b551c4e8f2994919997d4b9e2793e03c672f87141"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc384ce16fdf1885123d4ead2819429eb0cf7d541e8bc1c9105824bbdbdf0c10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82fbcae4fd78cfa7e7f6dc7abd4ec0a82775544a8fd94be4333352ece176b075"
    sha256 cellar: :any_skip_relocation, sonoma:        "72981c1702604ab001045a1b6301057bd0996a220a81836d163e1c4ca91c7487"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1c8eaf2e18ab87922b7c01559a7866243b0a7969c8eb6bb379163011adf55b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "558c45eb44c85afb0856a4a7090c6f6c2800e5b71da7707c950604b5dd2b1f98"
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
