class ZshAsync < Formula
  desc "Perform tasks asynchronously without external tools"
  homepage "https://github.com/mafredri/zsh-async"
  url "https://github.com/mafredri/zsh-async/archive/v1.8.5.tar.gz"
  sha256 "3ba4cbc6f560bf941fe80bee45754317dcc444f5f6114a7ebd40ca04eb20910a"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "f120012d4d9940d9ef0560f4b623de7729af50d1b6e688fccff0663ce3c3da1a"
  end

  uses_from_macos "zsh"

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
