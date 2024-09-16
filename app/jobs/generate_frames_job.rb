require 'open3'

class GenerateFramesJob < ApplicationJob
    queue_as :default

    def perform(stream_id, url, output_directory)
        command = [
            'ffmpeg',
            '-i', url,
            '-vf', 'fps=1,scale=1920:1080',
            '-vcodec', 'png',
            '-loglevel', 'repeat+level+verbose',
            "#{output_directory}/frame_%03d.png"
        ]

        puts "Stream ID: #{stream_id}"
        puts "URL: #{url}"
        puts "Output Directory: #{output_directory}"    
        puts "Command: #{command}"
        

        Open3.popen2e(*command) do |stdin, stdout_and_stderr, wait_thr|
            pid = wait_thr.pid
            Redis.new.set("generate_frames_job_pid_#{stream_id}", pid)
            while line = stdout_and_stderr.gets
                puts line   
                puts "GenerateFramesJob: PID: #{pid}"
            end
        
            # Wait for the process to finish
            exit_status = wait_thr.value
            puts "GenerateFramesJob: Exit status: #{exit_status}"
        end
    end
end
