class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v0.20.12.tar.gz"
  sha256 "90ec60e161da62e57321eac68fad6ae73613d033620d2f0243662a2e039dd628"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ccf9ff2350dae715e1db230defc787b9b6dd57b38e750ebb5bf5d70c0eb8405"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "980a716ef805fb78bc40048863ea7233f44efdbb62ebec90963a9ee87ae9da5e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99a8150a111ed3cea7f7296640015f993fbe0c8c1944511040b4d0af5d470d02"
    sha256 cellar: :any_skip_relocation, ventura:        "1d02dd1a75c3bbbef7ab73333c8b140115588c32d316c4eecb21dd616564e7b1"
    sha256 cellar: :any_skip_relocation, monterey:       "c4301a6e29e28d641d6364ec5156e5e4da9c5f67c6c1eb96fcd99bd579968ef9"
    sha256 cellar: :any_skip_relocation, big_sur:        "0def630df2da4105960e48b860c0ae469ebfcd1e6c81dc8cb347f0a2e780f5d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de2b68a39a38a54a7e3a5b6df3b4102a1bfd7c73826aae4791d2ea6f5e63328e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"steampipe", "completion")
  end

  test do
    if OS.mac?
      output = shell_output(bin/"steampipe service status 2>&1", 255)
      assert_match "Error: could not create installation directory", output
    else # Linux
      output = shell_output(bin/"steampipe service status 2>&1")
      assert_match "Steampipe service is not installed", output
    end
    assert_match "Steampipe v#{version}", shell_output(bin/"steampipe --version")
  end
end
