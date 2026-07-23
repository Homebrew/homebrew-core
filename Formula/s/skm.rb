class Skm < Formula
  desc "Simple and powerful SSH keys manager"
  homepage "https://timothyye.github.io/skm"
  url "https://github.com/TimothyYe/skm/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "6afce1a7d42167285fe074187708ff7538b866ac051c671a82f97b746d9f5204"
  license "MIT"
  head "https://github.com/TimothyYe/skm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ed415bd3d35429d897fa14d0a1aec89c66c03e7705c87550160403acc33c7c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ed415bd3d35429d897fa14d0a1aec89c66c03e7705c87550160403acc33c7c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ed415bd3d35429d897fa14d0a1aec89c66c03e7705c87550160403acc33c7c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "476ebbe10e2315191ecee0084d39217ece4018f043a13707c5efd511f8381da5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67f9dfebeb08cb10427d1729bf8b16941eafcf8ddeeff4ce4d884e82766a4cac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf4f321b5568eecb58d94f5b2daa5b5867234778fab0724c71f75e5c806a2e06"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/skm"
    bash_completion.install "completions/skm.bash"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skm --version")

    store = testpath/"store"
    ssh = testpath/"ssh"
    ssh.mkpath
    output = shell_output("#{bin}/skm --store-path #{store} --ssh-path #{ssh} init")
    assert_match "SSH key store initialized", output
    assert_predicate store, :directory?
  end
end
