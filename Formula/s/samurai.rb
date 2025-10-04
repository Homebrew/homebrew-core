class Samurai < Formula
  desc "Ninja-compatible build tool written in C"
  homepage "https://github.com/michaelforney/samurai"
  url "https://github.com/michaelforney/samurai/releases/download/1.2/samurai-1.2.tar.gz"
  sha256 "3b8cf51548dfc49b7efe035e191ff5e1963ebc4fe8f6064a5eefc5343eaf78a5"
  license "Apache-2.0"
  head "https://github.com/michaelforney/samurai.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "3cbfa0ba7e77472c117829bb5cd8dba6022f219beb688070730e10958908c85a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5dbf52962ed4a4191d77edd3b9970621f5f543ed42eb64d85673f7bc572f0a01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e254250616b85e30cde7a66f55af5bde58657622a82fab525e92ed2a6f8220cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef30fe2e4abb74c2d10c8465629b2f53238bad713d5f9f11a29edbeef4a3906f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98bc9f540b7344a3aa23402b3537a2a45842032026108de92f38ca2d1cda757e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "04ca3c9aada344360216791324e673db86948a3eaa2e82a541cb1fd28647b1bf"
    sha256 cellar: :any_skip_relocation, sonoma:         "d7b44a04b819915508167e1c0f3c928d31d329c87e76001e771db6009131fbe5"
    sha256 cellar: :any_skip_relocation, ventura:        "2dec5e545d8ad68b6a52ceda2195f50f6a717b390c83ac5cd052d431855fb666"
    sha256 cellar: :any_skip_relocation, monterey:       "34f2a7b813c145cf6deb49c67a476e22dbb2704329eb0a404a8c2c6821d41e20"
    sha256 cellar: :any_skip_relocation, big_sur:        "5e3819fa6eb240e781c236528297422575c6c2ae9aa4e38e6ddc7dbac0e25339"
    sha256 cellar: :any_skip_relocation, catalina:       "35e183246e80cfe5a6f9b11b12cd2e0c3a754da15b8fb7550b5716de9e219e8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "2a544e5af4acbc661a25ff6f15fd2e0fce9164055734a033e0347c55daa760d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e89f00f8f16b67e01a287801b7c442e5dafe0923304fa649612610e26f4c4540"
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    (testpath/"build.ninja").write <<~EOS
      rule cc
        command = #{ENV.cc} $in -o $out
      build hello: cc hello.c
    EOS
    (testpath/"hello.c").write <<~C
      #include <stdio.h>
      int main() {
        puts("Hello, world!");
        return 0;
      }
    C
    system bin/"samu"
    assert_match "Hello, world!", shell_output("./hello")
  end
end
