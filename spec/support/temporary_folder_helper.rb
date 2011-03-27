def setup_temporary_folder
  folder = Dir.pwd + '/spec/temporary'
  `mkdir -p #{folder}`
  folder
end

def destroy_temporary_folder(folder)
  `rm -rf #{folder}`
end