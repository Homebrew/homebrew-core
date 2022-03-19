class Ucloud < Formula
  desc "Official tool for managing UCloud services"
  homepage "https://www.ucloud.cn"
  url "https://github.com/ucloud/ucloud-cli/archive/0.1.37.tar.gz"
  sha256 "91c8153854b102dcd671c58976e35b056b3ed32258a6daea3755c8cb35aed742"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99d77eefb237043ab551e21c7bc5c4d8290987e92b2b06c5ede39d6a6946358d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3104755ba0d6f6c6ece54041f351b5626a1b6eab413f02ba1d6f7910ad145ca3"
    sha256 cellar: :any_skip_relocation, monterey:       "d3e402a2646997e17c4b585d898a05f8341a58753f16546b9c4bf7ad717bbda7"
    sha256 cellar: :any_skip_relocation, big_sur:        "e17891249c6853edd5e48bdb01417815944a593c2549fec53cb90797ed020878"
    sha256 cellar: :any_skip_relocation, catalina:       "360540194c9c3f46ecd1a7fbdb659908123afcc3fa44d093cd641a6e87282ff8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5326dd1f207ab2ac02a00c06d8231ec5895735a595d543fe3a670a2c93854e3"
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
