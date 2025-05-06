class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v2.16.0",
      revision: "7912f7ef4381533e3a9f98d7966211af1dd0f940"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16e73e45fca368c8214236995d0c35b192764306d468799d3a9e77ffa2591efd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc974754e526c5067077d344f1b66f88848a9e8f933789a0324a36cca8010561"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3c6e4771736a4cd5d8b1d904493a894d70fdec4827b2a8c6d44296ebd0b65db5"
    sha256 cellar: :any_skip_relocation, sonoma:        "16bfdeb146f0ab00f055f1116304d95806ba5508c6993f115124bd30aaa13416"
    sha256 cellar: :any_skip_relocation, ventura:       "4bd83e35ad8540593fa916ea5a871dec0fb288cf2c278ce91f46f0a7b749b069"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ac1717855e4f17f892888c29b9203be1fc61ec4d36bb9349b3c8e54915dfb52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17f9e9b54277a851a4e01adf13b2cb6386452f6fe5a32c10139d7f1601121237"
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
