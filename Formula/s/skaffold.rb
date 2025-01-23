class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v2.13.2",
      revision: "64621312014d9d749790bfee13cb459895a0cd5f"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "033d95cbfb3efe46149d5e0ea8fb46414638e7700a646d8451537ed086b57334"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "02e157ae43669179212bc2ca37078aadd2e04bb28334d360df210b8787773094"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9adbaa2e85767a9ae7d4d2dbeac7d2b1abd7c8a7c83026f4deb1b208e70ef1fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cacfa2db276e46dce163c052ba733d031e4adc9b763bd6f21a5fdba35db48943"
    sha256 cellar: :any_skip_relocation, sonoma:         "46e90ccc5d352f6a9d1ec567bb36785c52509244c0edb79b99371188799f334c"
    sha256 cellar: :any_skip_relocation, ventura:        "56183bd68c5d40e09dcd551e376c61ed1cf7b473d47fd5d14e046c3011828ff6"
    sha256 cellar: :any_skip_relocation, monterey:       "05531f13cf74fcdd0809fea17a6daf4ab424fc4bfee9027ffdeca59212ed22a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50754518d0b723112b7f267a0d805188018228c3e444bf580616eb3f3ae6df76"
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "out/skaffold"
    generate_completions_from_executable(bin/"skaffold", "completion")
  end

  test do
    (testpath/"Dockerfile").write "FROM scratch"
    output = shell_output("#{bin}/skaffold init --analyze").chomp
    assert_equal '{"builders":[{"name":"Docker","payload":{"path":"Dockerfile"}}]}', output
  end
end
