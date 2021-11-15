class Xplr < Formula
  desc "Hackable, minimal, fast TUI file explorer"
  homepage "https://github.com/sayanarijit/xplr"
  url "https://github.com/sayanarijit/xplr/archive/v0.16.4.tar.gz"
  sha256 "06fb3afecfc3afe0971bf66f2ff80e293ab8b6b670fea5991c4dfc74bc7c67f4"
  license "MIT"
  head "https://github.com/sayanarijit/xplr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d69f39d754818f28f159e674ec7c354176783cde049a47dd25e2d194daf108bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "03d3797d605b395a01a626023720ba719351eda045004ac6dd6c71e4b8bdd6b6"
    sha256 cellar: :any_skip_relocation, monterey:       "8f4da392520d0fa2aa92cfa2949e17f4f3283928c59b193508c89ac1e11bad24"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d1ce6f913a3b63405811af84b523ad1249450af3e36dc3fb558a5d26349d654"
    sha256 cellar: :any_skip_relocation, catalina:       "6a0d0efbf7dec5172e8ad3f48d0c48d17c2849ff703859087997fcd68e72559e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4bc20604cb2856f39e28ec8d65f6baa073f2be5642b13083374172c66a77797"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    input, = Open3.popen2 "SHELL=/bin/sh script -q output.txt"
    input.puts "stty rows 80 cols 130"
    input.puts bin/"xplr"
    input.putc "q"
    input.puts "exit"

    sleep 5
    File.open(testpath/"output.txt", "r:ISO-8859-7") do |f|
      contents = f.read
      assert_match testpath.to_s, contents
    end
  end
end
