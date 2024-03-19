class Ruler < Formula
  desc "Tool to abuse Exchange services"
  homepage "https://github.com/sensepost/ruler"
  url "https://github.com/sensepost/ruler/archive/refs/tags/2.5.0.tar.gz"
  sha256 "e7344c60c604fa08f73dd30978f6815979cc26ca78bca71e132d0c66cc152718"
  license "CC-BY-NC-SA-4.0"
  head "https://github.com/sensepost/ruler.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b1db97c959bbb99094e58e6fe0950bb4e00a377141ed4ab0461c27361d6e18d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b9f543b67ba8612482997883d5f2ebad9c53c1b8c056c3c44aecda5646793755"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b72f93e0a2ca38a44a5a153f9a3e9efa901ac145571ca41fecceeff699b5144"
    sha256 cellar: :any_skip_relocation, sonoma:         "656e85847f333ff6b9369cc508c421e5087cf5ccc7c7bf25b1930794c7fb62cf"
    sha256 cellar: :any_skip_relocation, ventura:        "92055e334d5affd6f35bbaff4d225eaba43a958b205f575fd3ad68fb49383077"
    sha256 cellar: :any_skip_relocation, monterey:       "ffe2bae704819afa45499582f22b201390cd9fb5856fc42abf389afef8c8290c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdeeee61a6a36f8e7087f5937178410a21805ffadfab5ff2bda31b2df3e1ffc5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    test_config = testpath/"config.yml"
    test_config.write <<~EOS
      username: ""
      email: ""
      password: ""
      hash: ""
      domain: ""
      userdn: "/o=First Organization/ou=Exchange Administrative Group(FYDIBOHF23SPDLT)/cn=Recipients/cn=0003BFFDFEF9FB24"
      mailbox: "0003bffd-fef9-fb24-0000-000000000000@outlook.com"
      rpcurl: "https://outlook.office365.com/rpc/rpcproxy.dll"
      rpc: false
      rpcencrypt: true
      ntlm: true
      mapiurl: "https://outlook.office365.com/mapi/emsmdb/"
    EOS

    output = shell_output("#{bin}/ruler --config #{test_config} check 2>&1", 1)
    assert_match "Missing username and/or email argument.", output
  end
end
