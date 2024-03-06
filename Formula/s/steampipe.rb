class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "c6ddf025d178b8a7495ea943997fec63b41fa4dc346afae816a8b3185352631b"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "df75596a0cb74f2a42b6dcb8c565238aa0541c5d4485bb2ea31b1009481dea00"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad92e3b4ad94d8b2798feb3f6c1b5f03e59389b087cf4855a3896598e611822d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c62ccbb7c80075191b01001f68e63c137e46e0f11ed57e918d761e1299c767fd"
    sha256 cellar: :any_skip_relocation, sonoma:         "48d0ebb7e83e7b3ecdc8916e6de4e6c91ef9be721b8ed8b91ef1864febbb6f32"
    sha256 cellar: :any_skip_relocation, ventura:        "8df058c87b4cee2368954244425d11e89cd3fdee4eab925bedce0a8ea0d47c3e"
    sha256 cellar: :any_skip_relocation, monterey:       "7c2cf480ec33f1b8156efc7db4a18f837e7630c16a6a7e4cf6214db5b1c3ac9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "968bdf01f8416b542f6cd00caf16fb73ea6261d266f39064cd2df1278c5b73bd"
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
