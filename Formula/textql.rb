class Textql < Formula
  desc "Executes SQL across text files"
  homepage "https://github.com/dinedal/textql"
  url "https://github.com/dinedal/textql/archive/2.0.3.tar.gz"
  sha256 "1fc4e7db5748938c31fe650e882aec4088d9123d46284c6a6f0ed6e8ea487e48"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04e3ffe6755c2cc9e2a74f5a698e209b82d564dd4242440d1517574f9cb1e804"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f78964c1ac61753863e8c1cf50cfc293606ee20ecb062c5002b350db0ddc2e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd027344a17ef0bc236b638e442fbe257a82e9504f050021750884c486db3371"
    sha256 cellar: :any_skip_relocation, ventura:        "374350748bd8ffd3854ea2de25e6a50ce9b5c1bb5e1dffeec9c0941ca5081811"
    sha256 cellar: :any_skip_relocation, monterey:       "68935f7d92a0d09f414bdab5d638d67d3e7b5e5cc9b256f30be8563c26d043aa"
    sha256 cellar: :any_skip_relocation, big_sur:        "84bb8f0f712da5618c74b46f86afffa5da7ade72a68e508e3037d590206f28f6"
    sha256 cellar: :any_skip_relocation, catalina:       "d33d111039e957631d3a77cd35413707b47e684638a2571e3719a17c0173b55d"
    sha256 cellar: :any_skip_relocation, mojave:         "b6d4fd5ee0a2d1758651f91c35e6bd40a832f0d997ec2a120268bfde03a48cfb"
    sha256 cellar: :any_skip_relocation, high_sierra:    "38cbf8cacc0dd7e29831c8c7fe9f0437473c164bee549defb8744d6ca3e53fcb"
    sha256 cellar: :any_skip_relocation, sierra:         "f7bcfcacbd0b3076037e4715dabd1d925ef52ec66a3018d7a0124d091a7711c5"
    sha256 cellar: :any_skip_relocation, el_capitan:     "9950b83cf4d7bf59d3bf54711a845ddcf27f31dd004150acce3b8011ca2874a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d491cd48d7e35debc11c6c9ffacec4538ed039a22d5b88302b6eed0e0d62fd1"
  end

  depends_on "glide" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/dinedal/textql").install buildpath.children

    cd "src/github.com/dinedal/textql" do
      system "glide", "install"
      system "go", "build", "-ldflags", "-X main.VERSION=#{version}",
             "-o", bin/"textql", "./textql"
      man1.install "man/textql.1"
      prefix.install_metafiles
    end
  end

  test do
    assert_equal "3\n",
      pipe_output("#{bin}/textql -sql 'select count(*) from stdin'", "a\nb\nc\n")
  end
end
