class TidyViewer < Formula
  desc "CLI csv pretty printer"
  homepage "https://github.com/alexhallam/tv"
  url "https://github.com/alexhallam/tv/archive/refs/tags/1.5.2.tar.gz"
  sha256 "3f950c1d05cc7fd5806a49a3f10a9437290e2b24ddf8402ec04d54c63d1a60d5"
  license "Unlicense"

  # Some tagged versions using a stable version format are marked as
  # "pre-release" on GitHub, so it's necessary to check releases.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "73a068ea1c90da7c42f7eb61e16429607c620c7519987417ba192aece9254d37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a88cb1c9ee8fbcc0fbe1245b414bc396e331e1ee2722eca091b60ac204988a48"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a19cf14db14c07f2ade52a99614d994acaac312c05c3143c60a6a5345f3a2896"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42a42abecc4680536319b6bbbfba8ace4fd18d725e6a1c3bd1edc669a8877b64"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a17bbc8e7d2b76d5e4495ad8ee47176fb075a1353821a3be5a712c8213aff57"
    sha256 cellar: :any_skip_relocation, sonoma:         "6641bc5ab6124cea8e7591a4c1b9cd750fa99628f49324d374612bd0d1814399"
    sha256 cellar: :any_skip_relocation, ventura:        "d3ba5ca8471a577a7c54ce300de86d77887e3ee366022588a58f5f89ef9d98c5"
    sha256 cellar: :any_skip_relocation, monterey:       "9e7ce7d415590691f06bad36b0d5270fb1bbad9ddfc046fc1f4f8c0473b0a593"
    sha256 cellar: :any_skip_relocation, big_sur:        "99d8e002b427e3a2a160faeda4e526115538431244faf52dd4bf041118347630"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "3e44fa91c0257cd46a249043bdf0594b447c8905d76e2d0646a538352f770e58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3058a55881b1a5874f31e848f613cee6f97f3891ff4091539323b4c189115fa"
  end

  depends_on "rust" => :build

  conflicts_with "television", because: "both install `tv` binaries"

  def install
    system "cargo", "install", *std_cargo_args
    bin.install_symlink "tidy-viewer" => "tv"
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    assert_match "first header", shell_output("#{bin}/tv #{testpath}/test.csv")
  end
end
