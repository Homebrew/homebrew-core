class Ucloud < Formula
  desc "Official tool for managing UCloud services"
  homepage "https://www.ucloud.cn"
  url "https://github.com/ucloud/ucloud-cli/archive/v0.1.39.tar.gz"
  sha256 "b56442ade45554be2dae0807958a863c286f0846f91d5008f276a7e8cce95c54"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77b3b55b46726375f370344a27774217967370557a32e4788ae22ecbbab27871"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6a379c8b60b05243c72eea9d53bd3c946b10188abe9f049d237bb295b6f220e"
    sha256 cellar: :any_skip_relocation, monterey:       "a44eace64637ae94807526b557020d47b9008a3dc1f2df14157132ee327a8baa"
    sha256 cellar: :any_skip_relocation, big_sur:        "f2731c2e7a1f6fb0c3a263205224e771aa61df91fa6c51c82d681139d0e86989"
    sha256 cellar: :any_skip_relocation, catalina:       "17934f41b92c713c06176465dc04ba890a0cfa773d4ef346cc176eaf3805792c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5f979af4b6fcbb73aecb8fcbafaff493cb5be558652df3c8c26e53b46b7de63"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    dir = buildpath/"src/github.com/ucloud/ucloud-cli"
    dir.install buildpath.children
    cd dir do
      system "go", "build", "-mod=vendor", "-o", bin/"ucloud"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/ucloud", "config", "--project-id", "org-test", "--profile", "default", "--active", "true"
    config_json = (testpath/".ucloud/config.json").read
    assert_match '"project_id":"org-test"', config_json
    assert_match version.to_s, shell_output("#{bin}/ucloud --version")
  end
end
