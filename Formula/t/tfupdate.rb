class Tfupdate < Formula
  desc "Update version constraints in your Terraform configurations"
  homepage "https://github.com/minamijoyo/tfupdate"
  url "https://github.com/minamijoyo/tfupdate/archive/v0.8.0.tar.gz"
  sha256 "2b0e59f42d73a2407826eff31d9ff4b7ee03d0129e72bfd31b9e54f13ccc5d20"
  license "MIT"
  head "https://github.com/minamijoyo/tfupdate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c47ad0dc719dd57d4006b9993d4ee4dda6c96489cc4055c69680247b786cc392"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c3840682b2f0158c706d7371edae4204706cc083c6a68bfaa63f0cd84a8f143"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "854e559ef5ac4150efe3b76af7696423983f63eed53b1070ce2205126af03b70"
    sha256 cellar: :any_skip_relocation, sonoma:         "79a338bd25e63c43b1df76b9883076ca9a48c46749c3271abfa42e3aed82eb0b"
    sha256 cellar: :any_skip_relocation, ventura:        "feb7c5a3603ef126b75fcae3481fdff91d95ac01f158338705388d799df3b25a"
    sha256 cellar: :any_skip_relocation, monterey:       "d1c290f17e207871153f01e98e788c9c4e1bccca147b5bd095dd33b05caa6da4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1190cd974b0b3be27a026ea2795169866545b63d838c9fe72732210c9e21217f"
  end

  depends_on "go" => :build
  depends_on "terraform" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"provider.tf").write <<~EOS
      provider "aws" {
        version = "2.39.0"
      }
    EOS

    system bin/"tfupdate", "provider", "aws", "-v", "2.40.0", testpath/"provider.tf"
    assert_match "2.40.0", File.read(testpath/"provider.tf")

    # list the most recent 5 releases
    assert_match Formula["terraform"].version.to_s, shell_output(bin/"tfupdate release list -n 5 hashicorp/terraform")

    assert_match version.to_s, shell_output(bin/"tfupdate --version")
  end
end
