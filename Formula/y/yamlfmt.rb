class Yamlfmt < Formula
  desc "Extensible command-line tool to format YAML files"
  homepage "https://github.com/google/yamlfmt"
  url "https://github.com/google/yamlfmt/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "79117ece08bd4175a88a1ec9fed703a10d1573750fe73c6e212d9c62b96e2369"
  license "Apache-2.0"
  head "https://github.com/google/yamlfmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4a73209def2fc4e07d41889e11cb7c82954d7d1c5051a7591342301c3e9f40e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3c46ca7a25fbf1b395616dded26c2fab581f2a2fb48e33d226e6bf1f9c11d0df"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2bdb15e3f06897b57fda481e39279ecf91b9310a5db4832c7ac101e65270edae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8d27c36ab5e0afc35c473c6ff5985e292e15b5d9776c72b9cc4ba209059a67a"
    sha256 cellar: :any_skip_relocation, sonoma:         "51eaac6c4a967dee980851e25bab10823d1409a65622b493ffd1f4f806f53499"
    sha256 cellar: :any_skip_relocation, ventura:        "b279664b7058f558995c93361e7634ce42a57d0876ae0518415910c989323b84"
    sha256 cellar: :any_skip_relocation, monterey:       "cea6269ca6471482f7f38616b41f6c43ce89163e296ef40c09eb82a9407de3f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1d38658401442429e4207bb7e08ba71514ddc0bf5c76ffd8e3dfa320b279b64"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/yamlfmt"
  end

  test do
    (testpath/"test.yml").write <<~YAML
      foo: bar
    YAML
    system bin/"yamlfmt", "-lint", "test.yml"
  end
end
