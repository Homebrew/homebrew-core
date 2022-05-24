class Wtfutil < Formula
  desc "Personal information dashboard for your terminal"
  homepage "https://wtfutil.com"
  url "https://github.com/wtfutil/wtf.git",
      tag:      "v0.41.0",
      revision: "fb027f1ec75b52137bc2828a8e0976a510b5591e"
  license "MPL-2.0"
  head "https://github.com/wtfutil/wtf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "328f632701bb230bb7c1f585eaa8e8302caee981132bee7ece771ea620068d93"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be10a4a93edcba84f41e3ee1963e846e1b0835d4ccf463a7ceef1aa949ea6063"
    sha256 cellar: :any_skip_relocation, monterey:       "854d20c1a7b251d6c696a43b53bccd951c3ae68848b294067a11a483d77bedf5"
    sha256 cellar: :any_skip_relocation, big_sur:        "f2b79ebab8e78ad546ef90e286907e85b7973c72be7678ee1f84d7d4c0a7bca9"
    sha256 cellar: :any_skip_relocation, catalina:       "8f0694be170caf23c9ca6e45acdc0992059adee1dbdd6d477095d2a211dcd368"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28ccf8bde8dda105bfaae2762d4a2f9bebdd58748fad6db78c1d4b12d6651253"
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
