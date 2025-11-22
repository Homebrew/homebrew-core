class Subfinder < Formula
  desc "Subdomain discovery tool"
  homepage "https://github.com/projectdiscovery/subfinder"
  url "https://github.com/projectdiscovery/subfinder/archive/refs/tags/v2.10.1.tar.gz"
  sha256 "fab71430b869ee26d4a44cd2b0685b80bd61326a9cd42925247f6a8eb6d4c4f7"
  license "MIT"
  head "https://github.com/projectdiscovery/subfinder.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5b41590312152c2dad9ed7baaa2752537e695aec33f1c099d9c27385a35ea92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02042ec11eea6d0ba3bb70e806f71a9e97b78cbd8833146a42b913b34042537c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ddb9f0907045ff85cd22dd71af17190d84d781c9f704fd07c92fcbb6d8606ffb"
    sha256 cellar: :any_skip_relocation, sonoma:        "806acaafd3c45ce83efa3332bdca94a69963b33fba09474992de35143f7a5c44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a4fb13fae46b37cbda757524625f68dc75dce118ba3dfa556f9cf76ae260419"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "845c84755125795326f37910025a286d8726e4cd006157361b9a5853b7dde464"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/subfinder"
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
