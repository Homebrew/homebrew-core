class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v2.6.3",
      revision: "c739946e43f7984ecd315061e8bf832e3e542aeb"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7aaa8b63ce54a4461fc86da1cbb7d1534b67594c9c9dc5fae5d3e0cefa08b315"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0bd9eb3e20018d8700eb0895c7739cd68617b0610a6d3c5fd7de8c48b76ae4fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e77c8138c19f80ce98d7f30418987e822e36be1f7cd6fc294019675261b37b49"
    sha256 cellar: :any_skip_relocation, ventura:        "2f3427bd67d300e161df6537ff9ce9c31984485af7843db7f091567b7d03271a"
    sha256 cellar: :any_skip_relocation, monterey:       "39a56f216c8f3083999f35eb98227f01020c9f1096d22586aa83cf431f21da3e"
    sha256 cellar: :any_skip_relocation, big_sur:        "f4d78c446a9a50b9e0e3b0686bb30839c177642c82febe715186b41339ef5345"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c3ea726a643b4bb0ff6d1cffb09b1ff870972e446a4c14001275d83cd66e793"
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
