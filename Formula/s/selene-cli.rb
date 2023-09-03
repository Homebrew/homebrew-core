class SeleneCli < Formula
  desc "Generation Swift source code from Env file"
  homepage "https://github.com/zunda-pixel/selene"
  url "https://github.com/zunda-pixel/selene.git",
      tag:      "1.1.1",
      revision: "703adbc3fced409da7ecf20ea2b7e162ff6f4986"
  license "Apache-2.0"
  head "https://github.com/zunda-pixel/selene.git", branch: "main"

  depends_on xcode: ["14.3", :build]

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/selene"
  end

  test do
    (testpath/".env").write <<~EOS
      key1=value1
      #key2=value2
      key3=value3=value3
    EOS
    shell_output("#{bin}/selene SecureEnv .env SecureEnv.swift")
    assert_predicate testpath/"SecureEnv.swift", :exist?
  end
end
