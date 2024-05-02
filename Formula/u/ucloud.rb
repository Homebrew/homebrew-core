class Ucloud < Formula
  desc "Official tool for managing UCloud services"
  homepage "https://www.ucloud.cn"
  url "https://github.com/ucloud/ucloud-cli/archive/refs/tags/v0.1.46.tar.gz"
  sha256 "7812984592b0ff16dbd721d6261a1ff2c422783f0c723943dd211db733878eb3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4671f0a7451aed9d48ee701cf300870893c8bd1aff1895796e5e33f250bf04e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0a71133b9d9c024df0bcbcf576dcfb6c9095eb9819541cd16064cf4b55cf200"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0c032470eba5927aad87f24f35655beb9e47070696f6ca4d27ecf7c9bc467b9"
    sha256 cellar: :any_skip_relocation, sonoma:         "a1d2497530bb5a2a2c119ff7d97eba2f31ca449334f50b8c9b5fa7ab3066e1da"
    sha256 cellar: :any_skip_relocation, ventura:        "5b1c616e4045be4b4868fc01cb252dfb8389e04c796ae2bcf28bc1dac46a17b2"
    sha256 cellar: :any_skip_relocation, monterey:       "a1d9fb484986d90633ef667fdb2ef7289bb69bf5247dc872b8758ca7f8c8d338"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b86669a512bb3fa5b24ba90ef98555dd287acb76b82069361f63ae0c4eb012e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-mod=vendor"
  end

  test do
    system bin/"ucloud", "config", "--project-id", "org-test", "--profile", "default", "--active", "true"
    config_json = (testpath/".ucloud/config.json").read
    assert_match '"project_id":"org-test"', config_json
    assert_match version.to_s, shell_output("#{bin}/ucloud --version")
  end
end
