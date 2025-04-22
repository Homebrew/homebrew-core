class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "2150324a8b72c38a370fbb4527f64c53d9af53b3508850d65a5ccfe206fa265d"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9accc6e0dca5851ccccf6f99d1171672361d0c48f1edde9b4649439cb481612e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9cb9120d8f8400bd0a1dd4887e3ca17b138dac828bfecf8d173f22979df9d4c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6cffe574bf756448e70e7e1ee599273f59507a2a4551b4089e90133c80271f77"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b162c429d398ec3369707b60eddffead5bc1ec59dc32dc7951c644cb3704e58"
    sha256 cellar: :any_skip_relocation, ventura:       "daded26f81659729e7a39ad16c4197f34987f574efd933d81ca841b07be25724"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2baf7e1cf096e9fd4cbcb41d7f1dd51617f67cf88aa51a5ddf00c33c92337b3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"steampipe", "completion")
  end

  test do
    if OS.mac?
      output = shell_output(bin/"steampipe service status 2>&1", 255)
      assert_match "Error: could not create logs directory", output
    else # Linux
      output = shell_output(bin/"steampipe service status 2>&1")
      assert_match "Steampipe service is not installed", output
    end
    assert_match "Steampipe v#{version}", shell_output(bin/"steampipe --version")
  end
end
