class ZshAsync < Formula
  desc "Perform tasks asynchronously without external tools"
  homepage "https://github.com/mafredri/zsh-async"
  url "https://github.com/mafredri/zsh-async/archive/v1.8.5.tar.gz"
  sha256 "3ba4cbc6f560bf941fe80bee45754317dcc444f5f6114a7ebd40ca04eb20910a"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "c1f30da09c587d1670b42fd489fa6507b3166633887565b17e7d5f4dc892f2ad" => :big_sur
    sha256 "290fae7722d9d181e362b5f5986085a3453a21a5d32adf5e7ea1aac1aaace462" => :arm64_big_sur
    sha256 "5f7835aa0c6c9d73dd63f6a27655f359caa76d34caec5ae0465bca2390349e50" => :catalina
    sha256 "bdf610a55644e4182b35307a946ecb6b3724fbade6dabae0dc1d655079b34614" => :mojave
  end

  def install
    zsh_function.install "async.zsh" => "async"
  end

  test do
    example = <<~ZSH
      source #{zsh_function}/async
      async_init

      # Initialize a new worker (with notify option)
      async_start_worker my_worker -n

      # Create a callback function to process results
      COMPLETED=0
      completed_callback() {
        COMPLETED=$(( COMPLETED + 1 ))
        print $@
      }

      # Register callback function for the workers completed jobs
      async_register_callback my_worker completed_callback

      # Give the worker some tasks to perform
      async_job my_worker print hello
      async_job my_worker sleep 0.3

      # Wait for the two tasks to be completed
      while (( COMPLETED < 2 )); do
        print "Waiting..."
        sleep 0.1
      done

      print "Completed $COMPLETED tasks!"
    ZSH
    assert_match "Completed 2 tasks!", shell_output("zsh -c '#{example}'")
  end
end
