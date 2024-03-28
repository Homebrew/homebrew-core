class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie.git",
    tag:      "v0.4.15",
    revision: "eadb194a7aae85bd41d60b9619c8689d41599bee"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "538434e20c684f4f62d936a520488289e71fc89a2764884f330a527f7fbf52fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd04b33bf0f2f5ed7dc3741abbba1a1a6ec105de49b8718ced864bc42cfc584a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb59c6dc9e73a0d248a24e86bb2076dfd8c89c23ca8a1523e4bc73b05433098e"
    sha256 cellar: :any_skip_relocation, sonoma:         "a14a135eb8d6deafd6a6cff52eda0470b3e700fa4f2d22d508ef60bc3865b086"
    sha256 cellar: :any_skip_relocation, ventura:        "ac6f619d37e7185532dedb24fe7c64f13f861b5f3e46cf5cd51646b272a7f989"
    sha256 cellar: :any_skip_relocation, monterey:       "d73cbf0108b23cced3187d1a980b4c10e22f5007f2c67dd951284d10c33b02b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4443929fe894da49ea1c485a79c01840555690f026930187e1004298f790db3f"
  end

  depends_on "go" => :build

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
    system bin/"yorkie", "login", "-u", "admin", "-p", "admin", "--insecure"

    test_project = "test"
    output = shell_output("#{bin}/yorkie project create #{test_project} 2>&1")
    project_info = JSON.parse(output)
    assert_equal test_project, project_info.fetch("name")
  ensure
    # clean up the process before we leave
    Process.kill("HUP", yorkie_pid)
  end
end
