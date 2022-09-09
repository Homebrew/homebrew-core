class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie.git",
    tag:      "v0.2.17",
    revision: "109ed36d485c92f123186e5e704a3946ca6c7db6"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7f2844be41c547046be0589d4f62166bde37096a1f5d1e98d5cc7d5e484b2da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e01cff1e8879cf0d7166e7c62b9582f70e6a35640414882cc0a389a10ae0019"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "689020d195e11b8b5d75cccb5f116c8bf4d597d22a3450b1d1bb04c783f3ef73"
    sha256 cellar: :any_skip_relocation, monterey:       "ade4a340f135b6290c4b6c9aa09e09e09c76046ce607ea06482096d2ee80b13c"
    sha256 cellar: :any_skip_relocation, big_sur:        "f57fd1c2ed703870cd138a6591395c3258499149ce6f61c8bf0b34fbfbf421b3"
    sha256 cellar: :any_skip_relocation, catalina:       "8f000883dc9aa994f1cb4916ec83f2743bb44d909243ac88f920f4017f468afd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf2bcf26b2a4ef76870c02c80ccd15a5598b3f5f6cf7bdc2320eaf0b8477cac8"
  end

  # Doesn't build with latest go
  # See https://github.com/yorkie-team/yorkie/issues/378
  depends_on "go@1.18" => :build

  def install
    system "make", "build"
    prefix.install "bin"

    generate_completions_from_executable(bin/"yorkie", "completion")
  end

  service do
    run opt_bin/"yorkie"
    run_type :immediate
    keep_alive true
    working_dir var
  end

  test do
    yorkie_pid = fork do
      exec bin/"yorkie", "server"
    end
    # sleep to let yorkie get ready
    sleep 3
    system bin/"yorkie", "login", "-u", "admin", "-p", "admin"

    test_project = "test"
    output = shell_output("#{bin}/yorkie project create #{test_project}")
    project_info = JSON.parse(output)
    assert_equal test_project, project_info.fetch("name")
  ensure
    # clean up the process before we leave
    Process.kill("HUP", yorkie_pid)
  end
end
