class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://github.com/budimanjojo/talhelper"
  url "https://github.com/budimanjojo/talhelper/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "33a01584aa8550875eef9376eb8c4bfda5429602b26a5eed0708653f67016f9a"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "22de33ac93fdf555d7ea63ce1c576ba2225dcf85d9fe97ebffeb77ad9104c4ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66993c7fb7f0bb71b3afebdf100e2620199e086d11515a91a929431570039198"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "337bc1f362fa032889964e1967bf7879f377ebc272f0519c0ca64766e9bcca79"
    sha256 cellar: :any_skip_relocation, sonoma:         "605f2dcb61487afe39ce0e1684178591318f186978a909636e91c5997d3022ed"
    sha256 cellar: :any_skip_relocation, ventura:        "31fc73807a5570330666d64c54fd771a2017354ac80d4eb4acee59789c96ba3f"
    sha256 cellar: :any_skip_relocation, monterey:       "093ab47e5b14fa0bdff83f02ff7ab916b175691c68b3d5a91f7480dd7f565094"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cccc0f17f5d8df02fd2d32b8b98a38663e09e0ffbd8f899b9b934d570ff9188a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/budimanjojo/talhelper/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"talhelper", "completion")
    pkgshare.install "example"
  end

  test do
    cp_r Dir["#{pkgshare}/example/*"], testpath

    output = shell_output("#{bin}/talhelper genconfig 2>&1", 1)
    assert_match "failed to decrypt/read env file talenv.yaml", output

    assert_match "cluster:", shell_output("#{bin}/talhelper gensecret")

    assert_match version.to_s, shell_output("#{bin}/talhelper --version")
  end
end
