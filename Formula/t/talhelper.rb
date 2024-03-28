class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://github.com/budimanjojo/talhelper/archive/refs/tags/v2.3.9.tar.gz"
  sha256 "5cc1cd7117eb7530e1735419022c9d9dc7eb07b0da6d8cb6feb6e97daf8db55b"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1f2ea1f4df776e824f06e2ad03927db28afeb6214f8468f0f26b338da70dbfe4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b22935200821c07cb64bd5dcb60dd2df519ab67d94a0e3acef129bd600bde011"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f1c5b174c97b16484128c7adef4aa64fc83598d58a68e3b42e43a48ee4112c8"
    sha256 cellar: :any_skip_relocation, sonoma:         "340263e0d88dd1946bd719db4dea68573c9a26cd379f7721ca900e70c78083f2"
    sha256 cellar: :any_skip_relocation, ventura:        "0881f8cca5ad061edd8e7bb5d2b2985906d7b8bdc330487cd6a64052b8aedb20"
    sha256 cellar: :any_skip_relocation, monterey:       "0d252d2709ffe696b223523cd9cc73e262d753241361539deb40c92b6ba6ef84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "847a8260116d77ddaf86dbf32716f8e19b26096cd1d2d247fab8830158c60154"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/budimanjojo/talhelper/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"talhelper", "completion")
    pkgshare.install "example"
  end

  test do
    cp_r Dir["#{pkgshare}/example/*"], testpath

    output = shell_output("#{bin}/talhelper genconfig 2>&1", 1)
    assert_match "failed to load env file: trying to decrypt talenv.yaml with sops", output

    assert_match "cluster:", shell_output("#{bin}/talhelper gensecret")

    assert_match version.to_s, shell_output("#{bin}/talhelper --version")
  end
end
