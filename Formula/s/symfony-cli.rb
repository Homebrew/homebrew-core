class SymfonyCli < Formula
  desc "Build, run, and manage Symfony applications"
  homepage "https://github.com/symfony-cli/symfony-cli"
  url "https://github.com/symfony-cli/symfony-cli/archive/refs/tags/v5.15.0.tar.gz"
  sha256 "504ee83ffc085adc5ecc5bf7e01ed029891c2854495a8ab2bc5874ff6e36997a"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60c318ece3717d6551daa1dbed7813e5f35901dd638f22b2294b097df35d5131"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cc71f1098bcfe76f2edbe989696944065900744a339785ca129bd5d722f71b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01a5c3181c080430541dc7ff2c4feafeaf49d23f97c763059b52dd921f653c83"
    sha256 cellar: :any_skip_relocation, sonoma:        "72bc9a7b006713238420472b120ddd144f74b7c7499143c3217b549e06d122e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bfde8a887d64a335534378ffa7b9ac3cd93feb5da5d1ec81f5966ef88cac5ca"
  end

  depends_on "go" => :build
  depends_on "composer" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.channel=stable", output: bin/"symfony")
  end

  test do
    system bin/"symfony", "new", "--no-git", testpath/"my_project"
    assert_path_exists testpath/"my_project/symfony.lock"
    output = shell_output("#{bin}/symfony -V")
    assert_match version.to_s, output
    assert_match "stable", output
  end
end
