class Vapor < Formula
  desc "Command-line tool for Vapor (Server-side Swift web framework)"
  homepage "https://vapor.codes"
  url "https://github.com/vapor/toolbox/archive/18.7.3.tar.gz"
  sha256 "5d9ef0f2d480bb35168cbafa547eacf3b2e6f2eaf1be9010cc3f5f6fef1fa580"
  license "MIT"
  head "https://github.com/vapor/toolbox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7c972d1e5338fdb0c019c115f835568802036baf084dd8af5cd1d7f05a8e5248"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a57f5cf7302a1f1357acd0ba7a3824f9c69cd7bf2b464bb64ae3abf005f12263"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1b0d34891703c9fb9fdc3b4f5b070063db5db5f1272838a156dcc3e3ee18eb9"
    sha256 cellar: :any_skip_relocation, sonoma:         "7d5c07222c5415eaa8ad71d35545d0b77c7d2444d0403bae85dd7983764857f2"
    sha256 cellar: :any_skip_relocation, ventura:        "28bdab0a59f68c40d8c93252f829a6191b9a9ab44fb03f73ea98a06621a6ba15"
    sha256 cellar: :any_skip_relocation, monterey:       "fd565d800adcd8d9661517a3b8bda7bdb2261c4cda0d38a2969507e73f27b6ee"
    sha256                               x86_64_linux:   "0768b1722d24f4a5427c98ed52886ebd8b0efa234bb77011f5752c1b8a1056f8"
  end

  # vapor requires Swift 5.6.0
  depends_on xcode: "13.3"

  uses_from_macos "swift", since: :big_sur

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "-Xswiftc",
      "-cross-module-optimization", "--enable-test-discovery"
    mv ".build/release/vapor", "vapor"
    bin.install "vapor"
  end

  test do
    system bin/"vapor", "new", "hello-world", "-n"
    assert_predicate testpath/"hello-world/Package.swift", :exist?
  end
end
