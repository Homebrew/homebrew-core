class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v0.21.7.tar.gz"
  sha256 "f9354c7a4527ed5cc953436b6e94c80b4c6fbe0df829bd413dd16a2b29d51337"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bbaa5442050b3892dc4dc6b3c3095b40299711a18532e6f56d0312cd426bdaee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "492a07a9f11053914748fe265af3520099bfee6c08202667235cb2a05f5c25a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8e9c1437fee0bf78a9edce708bd3ffa5ba6341fd3e8f351b2e711ee3860a8d5"
    sha256 cellar: :any_skip_relocation, sonoma:         "9da5b01de247331a223371ed3e70628e6e8fd602f42f43b10d740fa7cb316f3d"
    sha256 cellar: :any_skip_relocation, ventura:        "f1c894263eba2e7d305124e29544f8445a5003c0d04c46c218d46bdfbf686ab3"
    sha256 cellar: :any_skip_relocation, monterey:       "df0cb153348b12a0b9c77a0a9723b9194692f1916ca8d331fe85f5f5a46472c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a31f777ed156058e30a5c8215c18d815c8fc05f9901b663960f5a5026a0358ba"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"steampipe", "completion")
  end

  test do
    if OS.mac?
      output = shell_output(bin/"steampipe service status 2>&1", 255)
      assert_match "Error: could not create sample workspace", output
    else # Linux
      output = shell_output(bin/"steampipe service status 2>&1")
      assert_match "Steampipe service is not installed", output
    end
    assert_match "Steampipe v#{version}", shell_output(bin/"steampipe --version")
  end
end
