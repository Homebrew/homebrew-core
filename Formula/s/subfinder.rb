class Subfinder < Formula
  desc "Subdomain discovery tool"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/subfinder/archive/refs/tags/v2.15.0.tar.gz"
  sha256 "366398d8a1a98e7fb1aef9e7313d494d346d052b50b4b50d8019bb8a6d4e8566"
  license "MIT"
  head "https://github.com/projectdiscovery/subfinder.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de9b2b6f8ba05ea3684f2463b38afc0201cab73cd7f90876f1198e82f9e85a44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75c1d7db8b672b90bcd0420faa5f9a968c886e96aba2319aa4845171c628f4c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5137da995551aae585bc5e9e00098f9863244c98f590af516f6878d7227a0b12"
    sha256 cellar: :any_skip_relocation, sonoma:        "72b322d183219de0fd69ad7921c8bb89e3a3556cb1902b2973e9e11eac2f3760"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99a0a00ee707425ed45b6d56c36043cc86d0212c8bd48fc23e297f0eb0052d24"
    sha256 cellar: :any,                 x86_64_linux:  "dba2b0c2f9d8cc203284d502ceffd4abc201b3dd14ba18d80c147c76eba5c8e7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/subfinder"
  end

  test do
    assert_match "docs.brew.sh", shell_output("#{bin}/subfinder -d brew.sh")

    # upstream issue, https://github.com/projectdiscovery/subfinder/issues/1124
    config_prefix = if OS.mac?
      testpath/"Library/Application Support/subfinder"
    else
      testpath/".config/subfinder"
    end

    assert_path_exists config_prefix/"config.yaml"
    assert_path_exists config_prefix/"provider-config.yaml"

    assert_match version.to_s, shell_output("#{bin}/subfinder -version 2>&1")
  end
end
