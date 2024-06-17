class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/refs/tags/v8.357.16.tar.gz"
  sha256 "d2175d685606f1aa47987b6eeb346f1e7d84c6361a4c63f5873e6ae2290e81de"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1e905a29248871e4ba9806dac862fe56946fedf6b59cc8dc67d28d096b0aa363"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aee161b1ac186ab77a002957b5639aa4ff7e6ac86ad85f29b85f1dea9f365336"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0476684ee199dd4d591b8c3186ea49f95a806bd18319ae8fe0815eabf78512d2"
    sha256 cellar: :any_skip_relocation, sonoma:         "ebabf1d4f198bf73134e71768a659631377d460bc8e7b4d80f363214b6a2cda2"
    sha256 cellar: :any_skip_relocation, ventura:        "58db0ce0bb2072e3a1b62497ec18de0c72bca38b9ec20385f0ae1ba006200df3"
    sha256 cellar: :any_skip_relocation, monterey:       "5440db30d871cc7bf3de9ca5c759d6398b5c6cb62cf7198d27f57a9dcd010dbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfd2daff07a491544161a2086cc5291a82b3e626e089f58cb798d908f6dcac08"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s, PREFIX: prefix.to_s) do
        system "make", "install", "manpages"
      end
      generate_completions_from_executable(bin/"vespa", "completion")
    end
  end

  test do
    ENV["VESPA_CLI_HOME"] = testpath
    assert_match "Vespa CLI version #{version}", shell_output("#{bin}/vespa version")
    doc_id = "id:mynamespace:music::a-head-full-of-dreams"
    output = shell_output("#{bin}/vespa document get #{doc_id} 2>&1", 1)
    assert_match "Error: deployment not converged", output
    system "#{bin}/vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end
